const path = require('path')
const process = require('process')
const fs = require('fs')

const bindir = process.env.BAZEL_BINDIR
const execroot = process.env.JS_BINARY__EXECROOT

// Under Bazel, esbuild will follow symlinks out of the sandbox when the sandbox is enabled. See https://github.com/aspect-build/rules_esbuild/issues/58.
// This plugin using a separate resolver to detect if the the resolution has left the execroot (which is the root of the sandbox
// when sandboxing is enabled) and patches the resolution back into the sandbox.
function bazelSandboxPlugin() {
  return {
    name: 'bazel-sandbox',
    setup(build) {
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

          return await resolveInExecroot(build, importPath, otherOptions)
        }
      )
    },
  }
}

async function resolveInExecroot(build, importPath, otherOptions) {
  const result = await build.resolve(importPath, otherOptions)

  if (result.errors && result.errors.length) {
    // There was an error resolving, just return the error as-is.
    return result
  }

  // If the resolution points to a TypeScript file, check if a corresponding
  // JavaScript file exists and use that instead. This handles cases where tsconfig paths
  // resolve to the source .ts file, but we want to bundle the compiled .js file which
  // is present in the sandbox (via dependencies).
  if (result.path && !result.external) {
    const ext = path.extname(result.path)
    if (['.ts', '.tsx', '.mts', '.cts'].includes(ext)) {
      const jsExts = {
        '.ts': '.js',
        '.tsx': '.js',
        '.mts': '.mjs',
        '.cts': '.cjs',
      }
      const jsPath = result.path.substring(0, result.path.length - ext.length) + jsExts[ext]
      if (fs.existsSync(jsPath)) {
        if (!!process.env.JS_BINARY__LOG_DEBUG) {
          console.error(
            `DEBUG: [bazel-sandbox] falling back from ${result.path} to ${jsPath}`
          )
        }
        result.path = jsPath
      }
    }
  }

  // External modules are intentionally outside the bundle and don't need path validation
  if (result.external) {
    if (!!process.env.JS_BINARY__LOG_DEBUG) {
      console.error(
        `DEBUG: [bazel-sandbox] skipping sandbox validation for external module: ${result.path}`
      )
    }
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

  return correctImportPath(result, otherOptions, false)
}

function correctImportPath(result, otherOptions, firstEntry) {
  // If esbuild attempts to leave the execroot, map the path back into the execroot.
  if (!result.path.startsWith(execroot)) {
    // A relative path that is marked as external. If it was not marked as external, it would error in the build.resolve call.
    // We need to make it an absolute path from its importer and then re-attempt correcting it to be within the execroot.
    if (result.path.startsWith("..")) {
      const absPath = path.resolve(otherOptions.importer, result.path)
      if (!!process.env.JS_BINARY__LOG_DEBUG) {
        console.error(
          `DEBUG: [bazel-sandbox] relative & external path found ${result.path}, making absolute relative to its importer ${otherOptions.importer} and then reattempting making it relative to the execroot (${execroot}): ${absPath}`
        )
      }
      result.path = absPath
      return correctImportPath(result, otherOptions, true)
    }

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
  return result
}

module.exports = { bazelSandboxPlugin }
