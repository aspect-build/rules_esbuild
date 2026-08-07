const path = require('path')
const process = require('process')

const bindir = process.env.BAZEL_BINDIR
const execroot = process.env.JS_BINARY__EXECROOT

// Matches the bazel-out/<config>/bin segment of an absolute path. Used to detect and strip a
// bindir prefix instead of matching BAZEL_BINDIR exactly, because under Bazel's path-mapping
// feature BAZEL_BINDIR may hold a generic mapped placeholder (e.g. "bazel-out/cfg/bin") for
// cache-sharing purposes, rather than the real per-config value (e.g.
// "bazel-out/k8-fastbuild/bin") -- but once esbuild follows a symlink out of the sandbox and
// node resolves it to a real absolute path, that path always contains the *real* bindir segment,
// never the mapped one. The path is then reconstructed using `bindir` (see below), since that's
// the name the mapped sandbox's own directory tree actually uses on disk for this action.
//
// Matches both `/` and `\` as separators: BAZEL_BINDIR (from Bazel's Starlark-internal path
// representation) is always forward-slash, but a real resolved path on native Windows uses
// backslashes (see the startsWith('\\') check below for the same reason).
const BAZEL_OUT_BINDIR_RE = /bazel-out[\\/][^\\/]+[\\/]bin[\\/]/

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
    const bindirMatch = BAZEL_OUT_BINDIR_RE.exec(result.path)
    if (!bindirMatch) {
      throw new Error(
        `Error: esbuild resolved a path outside of bazel-out/*/bin: ${result.path}`
      )
    }
    // Otherwise remap the bindir-relative path, reconstructed under this action's actual
    // (possibly path-mapped) bindir rather than the real one baked into `result.path`.
    const relativeToBindir = result.path.substring(
      bindirMatch.index + bindirMatch[0].length
    )
    const correctedPath = path.join(execroot, bindir, relativeToBindir)
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
