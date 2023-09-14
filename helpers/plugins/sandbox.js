const path = require('path')
const process = require('process')

// Regex matching any non-relative import path
const pkgImport = /^[^.]/

// Under Bazel, esbuild likes to leave the sandbox, so make sure it
// stays inside the sandbox by using a separate resolver.
// https://github.com/aspect-build/rules_esbuild/issues/58
export function sandboxPlugin() {
  const bindir = process.env['BAZEL_BINDIR']
  const sandboxRoot = path.join(process.cwd().split(bindir)[0], bindir)
  return {
    name: 'sandbox',
    setup(build) {
      const moduleCache = new Map()
      build.onResolve({ filter: /./ }, async ({ path: importPath, ...otherOptions }) => {
        // NB: these lines are to prevent infinite recursion when we call `build.resolve`.
        if (otherOptions.pluginData) {
          if (otherOptions.pluginData.executedSandboxPlugin) {
            return
          }
        } else {
          otherOptions.pluginData = {}
        }
        otherOptions.pluginData.executedSandboxPlugin = true;

        // Prevent us from loading different forms of a module (CJS vs ESM).
        if (pkgImport.test(importPath)) {
          if (!moduleCache.has(importPath)) {
            moduleCache.set(importPath, resolveInSandbox())
          }
          return await moduleCache.get(importPath)
        }
        return await resolveInSandbox()

        async function resolveInSandbox() {
          const result = await build.resolve(importPath, otherOptions)

          // If esbuild attempts to leave the sandbox, map the path back into the sandbox.
          if (!result.path.startsWith(sandboxRoot)) {
            const pathPieces = result.path.split(bindir)
            if (pathPieces.length != 2) {
              // If it tried to leave bazel-bin, error out completely.
              throw new Error(
                `Error: esbuild resolved a path outside of BAZEL_BINDIR: ${result.path}`,
              )
            }
            result.path = path.join(sandboxRoot, pathPieces[1])
          }
          return result
        }
      })
    },
  }
}
