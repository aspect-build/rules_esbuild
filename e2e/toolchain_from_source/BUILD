load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")
load("@aspect_rules_esbuild//esbuild:toolchain.bzl", "esbuild_toolchain")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

# The esbuild rule expects a launcher script, which is a nodejs binary.
# However we aren't forced to use a nodejs script if there are no plugins written in JS.
# This simple script follows the same API: accept the flagfile (in JSON format)
# and use it to run the esbuild binary given the environment variable where it is found.
write_file(
    name = "esbuild_launcher.sh",
    out = "esbuild_launcher.sh",
    content = [
        """#!/usr/bin/env bash
cd $BAZEL_BINDIR
for arg in "$@"; do
    if [[ $arg == --esbuild_args=* ]]; then
        esbuild_args_file="${arg#*=}"
    fi
done
jq --raw-output '.entryPoints[]' $esbuild_args_file | xargs \
    $ESBUILD_BINARY_PATH \
    --outfile=$(jq --raw-output '.outfile' $esbuild_args_file) \
    --sourcemap --loader:.js=jsx
""",
    ],
)

sh_binary(
    name = "launcher",
    srcs = ["esbuild_launcher.sh"],
)

esbuild_toolchain(
    name = "binary_toolchain",
    launcher = ":launcher",
    target_tool = "@com_github_evanw_esbuild//cmd/esbuild:esbuild",
)

toolchain(
    name = "esbuild_binary_toolchain.registration",
    toolchain = ":binary_toolchain",
    toolchain_type = "@aspect_rules_esbuild//esbuild:toolchain_type",
)

esbuild(
    name = "bundle",
    srcs = ["index.js"],
    entry_point = "index.js",
)
