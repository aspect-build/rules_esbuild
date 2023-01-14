const _fs = require('fs');
// Use the _unpatched extension of fs from
// https://github.com/aspect-build/rules_js/pull/793.
const { readFileSync, writeFileSync, readdirSync, realpathSync } = _fs._unpatched || _fs;
const { pathToFileURL } = require('url')
const { join, resolve } = require('path')
const esbuild = require('esbuild')

function getFlag(flag, required = true) {
  const argvFlag = process.argv.find((arg) => arg.startsWith(`${flag}=`))
  if (!argvFlag) {
    if (required) {
      console.error(`Expected flag '${flag}' passed to launcher, but not found`)
      process.exit(1)
    }
    return
  }
  return argvFlag.split('=')[1]
}

function getEsbuildArgs(paramsFilePath) {
  try {
    return JSON.parse(readFileSync(paramsFilePath, { encoding: 'utf8' }))
  } catch (e) {
    console.error('Error while reading esbuild flags param file', e)
    process.exit(1)
  }
}

async function processConfigFile(configFilePath, existingArgs = {}) {
  const fullConfigFileUrl = pathToFileURL(join(process.cwd(), configFilePath))
  let config
  try {
    config = await import(fullConfigFileUrl)
  } catch (e) {
    console.error(
      `Error while loading configuration '${fullConfigFileUrl}':\n`,
      e
    )
    process.exit(1)
  }

  if (!config.default) {
    console.error(
      `Config file '${configFilePath}' was loaded, but did not export a configuration object as default`
    )
    process.exit(1)
  }

  config = config.default

  // These keys of the config can not be overriden
  const IGNORED_CONFIG_KEYS = [
    'bundle',
    'entryPoints',
    'external',
    'metafile',
    'outdir',
    'outfile',
    'preserveSymlinks',
    'sourcemap',
    'splitting',
    'tsconfig',
  ]

  const MERGE_CONFIG_KEYS = ['define']

  return Object.entries(config).reduce((prev, [key, value]) => {
    if (value === null || value === void 0) {
      return prev
    }

    if (IGNORED_CONFIG_KEYS.includes(key)) {
      console.error(
        `[WARNING] esbuild configuration property '${key}' from '${configFilePath}' will be ignored and overriden`
      )
    } else if (
      MERGE_CONFIG_KEYS.includes(key) &&
      existingArgs.hasOwnProperty(key)
    ) {
      // values from the rule override the config file
      // perform a naive merge
      if (Array.isArray(value)) {
        prev[key] = [...value, ...existingArgs[key]]
      } else if (typeof value === 'object') {
        prev[key] = {
          ...value,
          ...existingArgs[key],
        }
      } else {
        // can't merge
        console.error(
          `[WARNING] esbuild configuration property '${key}' from '${configFilePath}' could not be merged`
        )
      }
    } else {
      prev[key] = value
    }
    return prev
  }, {})
}

const bazelSandboxPlugin = {
  name: 'Bazel Sandbox Guard',
  setup(build) {
    // Generate an allowlist with all the files and the targets of symlinks from
    // the bin directory for this execution.
    //
    // Note that process.cwd() appears to already be BAZEL_BINDIR.
    const sandbox = new SandboxContents(process.cwd());
    // See https://esbuild.github.io/plugins/#on-load-arguments for docs about
    // onLoad.
    build.onLoad({ filter: /.*/ }, args => {
      sandbox.checkFileIsInSandbox(args.path);
    });
  }
}


// process.exit(1);

if (!process.env.ESBUILD_BINARY_PATH) {
  console.error('Expected environment variable ESBUILD_BINARY_PATH to be set')
  process.exit(1)
}

async function runOneBuild(args, userArgsFilePath, configFilePath) {
  if (userArgsFilePath) {
    args = {
      ...args,
      ...getEsbuildArgs(userArgsFilePath),
    }
  }

  if (configFilePath) {
    const config = await processConfigFile(configFilePath, args)
    args = {
      ...args,
      ...config,
    }
  }

  // If running under rules_js, add a plugin that attempts to restrict file
  // system access within the sandbox.
  if (process.env.BAZEL_BINDIR) {
    if (args.hasOwnProperty('plugins')) {
      args.plugins.push(bazelSandboxPlugin)
    } else {
      args.plugins = [bazelSandboxPlugin]
    }

    // Never preserve symlinks as this breaks the pnpm node_modules layout.
    args.preserveSymlinks = false
  }

  try {
    const result = await esbuild.build(args)
    if (result.metafile) {
      const metafile = getFlag('--metafile');
      writeFileSync(metafile, JSON.stringify(result.metafile));
    }
  } catch (e) {
    console.error(e)
    process.exit(1)
  }
}

/**
 * An index of files within the sandbox and some methods for checking that a
 * given path is within the sandbox.
 */
class SandboxContents {
  /**
   * @param {string} sandboxRoot Path to root of sandbox.
   */
  constructor(sandboxRoot) {
    this._files = listAllFiles(sandboxRoot);
    this._allowedPaths = new Set();
    this._files.forEach(f => {
      this._allowedPaths.add(f.realPathResolved);
      this._allowedPaths.add(f.pathResolved);
    });
  }

  /**
   * Returns true if the given path is in the sandbox.
   *
   * @param {string} absPath The absolute path of some file.
   * @returns {boolean} true if the file is in the sandbox.
   */
  inSandbox(absPath) {
    return this._allowedPaths.has(absPath);
  }

  /**
   * @returns {string} debug summary of the sandbox contents.
   */
  sandboxSummary(indent) {
    indent = indent || '';
    return this._files.map((entry) => {
      if (entry.isSymbolicLink) {
        return `${indent}${entry.pathResolved} ->\n${indent}  ${entry.realPathResolved}`;
      }
      return indent + entry.realPathResolved;
    }).join('\n');
  }

  /**
   * @param {string} somePath path to some file.
   * @throws {Error} if the path is not in the sandbox.
   */
  checkFileIsInSandbox(somePath) {
    const absPath = resolve(realpathSync(somePath));
    if (this.inSandbox(absPath)) {
      return;
    }
    
    throw new Error(
      `loaded file is not allowed because the file is not within the bazel ` +
      `sandbox. Check the deps of the esbuild rule. \n` +
      `${absPath} is not in list of ${this._files.length} sandbox entries:\n` + 
      `${this.sandboxSummary()}`);
  }
}

function listAllFiles(folder) {
  const out = [];
  readdirSync(folder, {withFileTypes: true}).forEach(file => {
    const fileName = join(folder, file.name);
    if (file.isDirectory()) {
      out.push(...listAllFiles(fileName));
    } else {
      const realPath = realpathSync(fileName);
      out.push({
        path: fileName,
        pathResolved: resolve(fileName),
        isSymbolicLink: file.isSymbolicLink(),
        realPathResolved: resolve(realPath),
      });
    }
  });
  return out;
}

runOneBuild(
  getEsbuildArgs(getFlag('--esbuild_args')),
  getFlag('--user_args', false),
  getFlag('--config_file', false)
)
