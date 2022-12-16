#!/usr/bin/env bash
# Produce a dictionary for the current esbuild release,
# suitable for appending to esbuild/private/versions.bzl

set -o errexit

echo "    $(curl --silent "https://registry.npmjs.org/esbuild/latest" | jq ".version"): {"
echo "        \"npm\": $(curl --silent "https://registry.npmjs.org/esbuild/latest" | jq ".dist.integrity"),"
for pkg in darwin-{x,arm}64 linux-{x,arm}64 win32-x64; do
    echo "        \"$pkg\": $(curl --silent "https://registry.npmjs.org/@esbuild/${pkg}/latest" | jq ".dist.integrity"),"
done
echo "    },"
echo
echo "Now paste the code block above into /esbuild/private/versions.bzl"