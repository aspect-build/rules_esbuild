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

You'll commonly find that you develop in another WORKSPACE, such as
some other ruleset that depends on rules_esbuild, or in a nested
WORKSPACE in the integration_tests folder.

To always tell Bazel to use this directory rather than some release
artifact or a version fetched from the internet, run this from this
directory:

```sh
OVERRIDE="--override_repository=rules_esbuild=$(pwd)/rules_esbuild"
echo "common $OVERRIDE" >> ~/.bazelrc
```

This means that any usage of `@rules_esbuild` on your system will point to this folder.

## Releasing

Press the button on https://github.com/aspect-build/rules_esbuild/actions/workflows/tag.yaml

If needed, you can manually push a specific v1.2.3-style tag instead.
