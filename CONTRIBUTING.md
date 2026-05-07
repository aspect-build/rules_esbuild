# How to Contribute

## Formatting

Starlark files should be formatted by buildifier.
We suggest using a pre-commit hook to automate this.
First [install pre-commit](https://pre-commit.com/#installation),
then run

```shell
pre-commit install
```

Otherwise later tooling on CI may yell at you about formatting/linting violations.

## Updating BUILD files

Some targets are generated from sources.
Currently this is just the `bzl_library` targets.
Run `aspect configure` to keep them up-to-date.

## Using this as a development dependency of other rules

You'll commonly find that you develop in another module, such as
some other ruleset that depends on rules_esbuild, or in a nested
module in the `e2e/` folder.

To tell Bazel to use this directory rather than a released artifact
or a version fetched from the registry, add a `local_path_override` to
the consumer's `MODULE.bazel`:

```starlark
bazel_dep(name = "aspect_rules_esbuild", version = "0.0.0")
local_path_override(
    module_name = "aspect_rules_esbuild",
    path = "/path/to/rules_esbuild",
)
```

The `e2e/*/MODULE.bazel` files in this repo demonstrate this pattern.

## Releasing

Press the button on https://github.com/aspect-build/rules_esbuild/actions/workflows/tag.yaml

If needed, you can manually push a specific v1.2.3-style tag instead.
