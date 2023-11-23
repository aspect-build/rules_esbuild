#!/usr/bin/env bash
# Produce a dictionary for the current esbuild release,
# suitable for appending to esbuild/private/versions.bzl

set -o errexit -o nounset -o pipefail
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
VERSIONS_BZL="$SCRIPT_DIR/../esbuild/private/versions.bzl"

# Gather integrity hashes for the most recent release
PKGS=""
for pkg in darwin-{x,arm}64 linux-{x,arm}64 win32-x64; do
    PKGS="$PKGS        \"$pkg\": $(curl --silent "https://registry.npmjs.org/@esbuild/${pkg}/latest" | jq ".dist.integrity"),"
done
# Remove final trailing comma so it's valid JSON
PKGS=${PKGS%,}

# Construct a JSON document representing the latest release
NEW=$(mktemp)
(
    echo "{ $(curl --silent "https://registry.npmjs.org/esbuild/latest" | jq ".version"): {"
    echo "        \"npm\": $(curl --silent "https://registry.npmjs.org/esbuild/latest" | jq ".dist.integrity"),"
    echo "$PKGS"    
    echo "    }"
    echo "}"
)> $NEW

# Read existing versions by using a python interpreter, which is easier than running a starlark program
CURRENT=$(mktemp)
python3 -c "import json; exec(open('$VERSIONS_BZL').read()); print(json.dumps(TOOL_VERSIONS))" > $CURRENT

# Combine the JSON documents, with the new version replacing matching keys
OUT=$(mktemp)
jq --slurp '.[0] * .[1]' $NEW $CURRENT > $OUT

# Locate the TOOL_VERSIONS declaration in the source file and replace it
sed '/TOOL_VERSIONS =/Q' $VERSIONS_BZL > $NEW
echo -n "TOOL_VERSIONS = " >> $NEW
cat $OUT >> $NEW
cp $NEW $VERSIONS_BZL
