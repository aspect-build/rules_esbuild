# Bazel rules for esbuild

This is a Bazel rule which wraps the esbuild CLI.

Features:

- Same API as the `@bazel/esbuild` package, so it's easy to migrate.
- Use the Bazel downloader to fetch the npm package and the native binaries as described here:
  <https://esbuild.github.io/getting-started/#download-a-build>.
  This means that the toolchain is fully self-contained and hermetic, and doesn't require you to
  put esbuild in your package.json. These rules never run `npm install`.

_Need help?_ This ruleset has support provided by https://aspect.build/services.

## Installation

From the release you wish to use:
<https://github.com/aspect-build/rules_esbuild/releases>
copy the WORKSPACE snippet into your `WORKSPACE` file.

## Usage

See the [API documentation](./docs/rules.md),
and the example usage in the [`examples/`](https://github.com/aspect-build/rules_esbuild/tree/main/examples/) directory.
Note that the examples rely on code in the `/WORKSPACE` file in the root of this repo.

## From a BUILD file

The simplest usage is with the [`esbuild` macro](./docs/rules.md#esbuild).

If needed, instead of the macro you could call the underlying [`esbuild_bundle` rule](./docs/esbuild.md#esbuild_bundle) directly.

# In a macro

You could write a Bazel macro which uses esbuild, by calling it from a `genrule` or
[`run_binary`](https://docs.aspect.build/bazelbuild/bazel-skylib/1.2.1/docs/run_binary_doc_gen.html#run_binary).
For this purpose, you can use the `ESBUILD_BIN` Make variable exposed by the
`@aspect_rules_esbuild//esbuild:resolved_toolchain`.
This is illustrated in examples/macro.

# In a custom rule

The most advanced usage is to write your own custom rule.

This is a good choice if you need to integrate with other Bazel rules via [Providers](https://docs.bazel.build/versions/main/skylark/rules.html#providers).

You can follow the example of `/esbuild/defs.bzl` by re-using the `lib` starlark struct exposed by
`/esbuild/private/esbuild.bzl`.
Note that this is a private API which can change without notice.

## Custom Toolchain

You can register your own toolchain to provide an esbuild binary.
For example, you could build esbuild from source within the Bazel build, so that you can freely
edit or patch esbuild and have those changes immediately reflected.
You'll need these things:

1. A rule which builds or loads an esbuild binary, for example a `go_binary` rule.
2. An `esbuild_toolchain` rule which depends on that binary from step 1 as the `target_tool`.
3. A [`toolchain` rule](https://bazel.build/reference/be/platform#toolchain) which depends on
   that target from step 2 as its `toolchain` and
   `@aspect_rules_esbuild//esbuild:toolchain_type` as its `toolchain_type`.
4. A call to [the `register_toolchains` function](https://bazel.build/rules/lib/globals#register_toolchains)
   in your `WORKSPACE` that refers to the `toolchain` rule defined in step 3.
