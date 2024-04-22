const { existsSync, statSync, readFileSync } = require('fs')
const { readFile } = require('fs/promises')
const path = require('path')
const process = require('process')

// Regex matching any non-relative import path
const pkgImport = /^[^.]/

const bindir = process.env.BAZEL_BINDIR
const execroot = process.env.JS_BINARY__EXECROOT


const USE_OLD_METHOD = false;
const ENABLE_CACHE = true;
const CHECK_CORRECTNESS = false;
// This provides a super mild performance boost
const ENABLE_RESOLVE_CACHE = false;


// Under Bazel, esbuild will follow symlinks out of the sandbox when the sandbox is enabled. See https://github.com/aspect-build/rules_esbuild/issues/58.
// This plugin using a separate resolver to detect if the the resolution has left the execroot (which is the root of the sandbox
// when sandboxing is enabled) and patches the resolution back into the sandbox.
function bazelSandboxPlugin() {
  return {
    name: 'bazel-sandbox',
    setup(build) {
      const moduleCache = new Map()
      let relativePathTime = 0;
      let relativePathCount = 0;
      let otherPathTime = 0;
      let otherPathCount = 0;
      let totalTime = 0;

      const resolveExtensions = ['', ...(build.initialOptions.resolveExtensions ?? ['.tsx', '.ts', '.jsx', '.js', '.css', '.json'])];

      console.error(build.initialOptions);


      build.onEnd(() => {
        console.error('Total Time resolving:', totalTime);
        console.error(`Relative ${relativePathTime}/${relativePathCount} = ${relativePathTime / relativePathCount}`);
        console.error(`Other ${otherPathTime}/${otherPathCount} = ${otherPathTime / otherPathCount}`);
        console.error(`Duplicates: ${duplicates}`)
        throw new Error('Oh fuck')
      })

      build.onResolve(
        { filter: /./ },
        async ({ path: importPath, ...otherOptions }) => {
          // NB: these lines are to prevent infinite recursion when we call `build.resolve`.
          if (otherOptions.pluginData) {
            if (otherOptions.pluginData.executedSandboxPlugin) {
              return
            }
          } else {
            otherOptions.pluginData = {}
          }
          otherOptions.pluginData.executedSandboxPlugin = true

          // Prevent us from loading different forms of a module (CJS vs ESM).
          if (pkgImport.test(importPath)) {
            if (!moduleCache.has(importPath)) {
              otherPathCount += 1;
              const start = Date.now();
              moduleCache.set(
                importPath,
                resolveInExecroot(build, importPath, otherOptions, resolveExtensions)
              )
              const duration = Date.now() - start;
              otherPathTime += duration;
              totalTime += duration;
            }
            return await moduleCache.get(importPath)
          }
          const start = Date.now();
          if (importPath.startsWith('.')) {
            relativePathCount += 1;
          } else {
            otherPathCount += 1;
          }
          const p = await resolveInExecroot(build, importPath, otherOptions, resolveExtensions)
          const duration = Date.now() - start;
          if (importPath.startsWith('.')) {
            relativePathTime += duration;
          } else {
            otherPathTime += duration;
          }
          totalTime += duration;


          return p
        }
      )
    },
  }
}

const cachedPkgJsons = new Map();
const existingResolves = {};
const cachedResolve = new Map();

async function resolveInExecroot(build, importPath, otherOptions, resolveExtensions) {
  let result;

  let remappings = {};
  let cachePath;
  if (!USE_OLD_METHOD && importPath.startsWith('.') && !importPath.includes('node_modules')) {
    // if it's relative, we *probably* don't need to realpath
    let newPath = path.join(otherOptions.resolveDir, importPath);
    cachePath = newPath;

    if (ENABLE_RESOLVE_CACHE) {
      const existingResult = cachedResolve.get(newPath);
      if (existingResult) {
        return existingResult;
      }
    }

    let dir = newPath;
    let fetchedFromCache = false;
    let remappings = {};


    while (dir.startsWith(execroot)) {

      let cachedVersion = cachedPkgJsons.get(dir);
      if (cachedVersion) {
        remappings = cachedVersion;
        fetchedFromCache = true;
        break;
      }

      const pkgJsonPath = path.join(dir, 'package.json');

      if (existsSync(pkgJsonPath)) {
        const pkgJson = JSON.parse(readFileSync(pkgJsonPath));
        browserReplacements = pkgJson.browser;

        if (browserReplacements) {
          if (typeof browserReplacements === 'string') {
            // I think the only time this matters is when loading the module directly which won't matter for us
            // since we're using relative imports
          } else {
            for (const key of Object.keys(browserReplacements)) {
              if (browserReplacements[key] === false) {
                remappings[path.join(dir, key)] = false;
              } else {
                remappings[path.join(dir, key)] = path.join(dir, browserReplacements[key]);

              }
            }
          }
        }


        break;
      }

      dir = path.dirname(dir)
    }


    const stats = statSync(newPath, { throwIfNoEntry: false });

    if (stats && stats.isDirectory()) {
      newPath = path.join(newPath, 'index');
    }


    let cachePointer = path.dirname(newPath);


    if (ENABLE_CACHE && remappings && !fetchedFromCache) {
      cachedPkgJsons.set(dir, remappings);

      while (cachePointer !== dir) {
        cachedPkgJsons.set(cachePointer, remappings);

        cachePointer = path.dirname(cachePointer);
      }
    }


    for (const ext of resolveExtensions) {
      const pathWithExt = `${newPath}${ext}`;

      const stats = statSync(pathWithExt, { throwIfNoEntry: false });

      if (stats) {

        if (stats.isDirectory()) {
          throw new Error('Should not be possible');
        } else {
          result = {
            path: remappings[pathWithExt] ?? pathWithExt
          };

          if (result.path === false) {
            const buildResult = await build.resolve(importPath, otherOptions)
            result.path = buildResult.path;
          }

          break;
        }
      }
    }

    if (!result) {
      result = {
        errors: [`Could not find any matching path for ${newPath}`]
      }
    }

    if (CHECK_CORRECTNESS) {
      const buildResult = await build.resolve(importPath, otherOptions)
      const correctedPath = path.join(
        execroot,
        buildResult.path.substring(buildResult.path.indexOf(bindir))
      )
      if (result.path !== correctedPath) {
        console.error('=========== Mismatch ================')
        console.error('pkgJsonDir:', dir)
        console.error('Remapping:', remappings);
        console.error('Import Path:', importPath);
        console.error('Other Options:', otherOptions);
        console.error('Result Path:', buildResult.path);
        console.error('execroot:', execroot);
        console.error('bindir:', bindir);
        console.error('Ours:', result.path)
        console.error('Correct:', correctedPath);
      }

    }

  } else {


    const buildResult = await build.resolve(importPath, otherOptions)
    result = buildResult;
    console.error(importPath, otherOptions);

  }




  if (result.errors && result.errors.length) {
    // There was an error resolving, just return the error as-is.
    return result
  }

  if (
    !result.path.startsWith('.') &&
    !result.path.startsWith('/') &&
    !result.path.startsWith('\\')
  ) {
    // Not a relative or absolute path. Likely a module resolution that is marked "external"
    return result
  }

  // If esbuild attempts to leave the execroot, map the path back into the execroot.
  if (!result.path.startsWith(execroot)) {
    // If it tried to leave bazel-bin, error out completely.
    if (!result.path.includes(bindir)) {
      throw new Error(
        `Error: esbuild resolved a path outside of BAZEL_BINDIR (${bindir}): ${result.path}`
      )
    }
    // Otherwise remap the bindir-relative path
    const correctedPath = path.join(
      execroot,
      result.path.substring(result.path.indexOf(bindir))
    )

    if (!!process.env.JS_BINARY__LOG_DEBUG) {
      console.error(
        `DEBUG: [bazel-sandbox] correcting esbuild resolution ${result.path} that left the sandbox to ${correctedPath}.`
      )
    }
    result.path = correctedPath
  }

  if (ENABLE_RESOLVE_CACHE && cachePath) {
    cachedResolve.set(cachePath, result);
  }

  return result
}

module.exports = { bazelSandboxPlugin }
