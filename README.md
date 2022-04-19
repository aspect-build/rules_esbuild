# Bazel rules for esbuild

This is a Bazel rule which wraps the esbuild CLI.

Features:

- Same API as the `@bazel/esbuild` package, so it's easy to migrate.
- Use the Bazel downloader to fetch the npm package and the native binaries as described here:
  <https://esbuild.github.io/getting-started/#download-a-build>.
  This means that the toolchain is fully self-contained and hermetic, and doesn't require you to
  put esbuild in your package.json. These rules never run `npm install`.

## Usage

See the API documentation in the `docs/` directory,
and the examples of usage in the `examples/` directory.

## Installation

From the release you wish to use:
<https://github.com/aspect-build/rules_esbuild/releases>
copy the WORKSPACE snippet into your `WORKSPACE` file.
