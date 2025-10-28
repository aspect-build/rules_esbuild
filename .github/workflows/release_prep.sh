#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# Argument provided by reusable workflow caller, see
# https://github.com/bazel-contrib/.github/blob/d197a6427c5435ac22e56e33340dff912bc9334e/.github/workflows/release_ruleset.yaml#L72
TAG=$1
# The prefix is chosen to match what GitHub generates for source archives
PREFIX="rules_esbuild-${TAG:1}"
ARCHIVE="rules_esbuild-$TAG.tar.gz"

# NB: configuration for 'git archive' is in /.gitattributes
git archive --format=tar --prefix=${PREFIX}/ ${TAG} | gzip > $ARCHIVE
SHA=$(shasum -a 256 $ARCHIVE | awk '{print $1}')

# Add generated API docs to the release
# See https://github.com/bazelbuild/bazel-central-registry/blob/main/docs/stardoc.md
docs="$(mktemp -d)"; targets="$(mktemp)"
bazel --output_base="$docs" query --output=label --output_file="$targets" 'kind("starlark_doc_extract rule", //...)'
bazel --output_base="$docs" build --target_pattern_file="$targets"
tar --create --auto-compress \
    --directory "$(bazel --output_base="$docs" info bazel-bin)" \
    --file "$GITHUB_WORKSPACE/${ARCHIVE%.tar.gz}.docs.tar.gz" .

cat << EOF
## Using [Bzlmod] with Bazel 6:

Add to your \`MODULE.bazel\` file:

\`\`\`starlark
bazel_dep(name = "aspect_rules_esbuild", version = "${TAG:1}")
\`\`\`

[Bzlmod]: https://bazel.build/build/bzlmod

## Using WORKSPACE

\`\`\`starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "aspect_rules_esbuild",
    sha256 = "${SHA}",
    strip_prefix = "${PREFIX}",
    url = "https://github.com/aspect-build/rules_esbuild/releases/download/${TAG}/${ARCHIVE}",
)
EOF
awk 'f;/--SNIP--/{f=1}' e2e/smoke/WORKSPACE.bazel
echo "\`\`\`"

cat << EOF
To use rules_esbuild with bazel-lib 2.0, you must additionally register the coreutils toolchain.
\`\`\`starlark
load("@aspect_bazel_lib//lib:repositories.bzl", "register_coreutils_toolchains")
register_coreutils_toolchains()
\`\`\`
EOF