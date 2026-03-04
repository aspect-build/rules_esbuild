#!/usr/bin/env bash
# The esbuild rule expects a launcher script, which is a nodejs binary.
# However we aren't forced to use a nodejs script if there are no plugins written in JS.
# This simple script follows the same API: accept the flagfile (in JSON format)
# and use it to run the esbuild binary given the environment variable where it is found.

set -o errexit -o nounset -o pipefail

cd $BAZEL_BINDIR
for arg in "$@"; do
    if [[ $arg == --esbuild_args=* ]]; then
        esbuild_args_file="${arg#*=}"
    fi
done
entry_points=$(sed -n 's/.*"entryPoints":\["\([^]]*\)"\].*/\1/p' $esbuild_args_file | tr '","' ' ')
outfile=$(sed -n 's/.*"outfile":"\([^"]*\)".*/\1/p' $esbuild_args_file)
echo $entry_points | xargs \
    $ESBUILD_BINARY_PATH \
    --outfile=$outfile \
    --sourcemap --loader:.js=jsx
