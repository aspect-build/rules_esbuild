"""Starlark helper to fetch rules_esbuild dependencies.

Should be replaced by bzlmod for users of Bazel 6.0 and above.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

# WARNING: any changes in this function may be BREAKING CHANGES for users
# because we'll fetch a dependency which may be different from one that
# they were previously fetching later in their WORKSPACE setup, and now
# ours took precedence. Such breakages are challenging for users, so any
# changes in this function should be marked as BREAKING in the commit message
# and released only in semver majors.
def rules_esbuild_dependencies():
    # The minimal version of bazel_skylib we require
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "c6966ec828da198c5d9adbaa94c05e3a1c7f21bd012a0b29ba8ddbccb2c93b0d",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
        ],
    )
    maybe(
        http_archive,
        name = "aspect_bazel_lib",
        sha256 = "a8b47eeaf3c1bd41c4f4b633ef4c959daf83fdee343379495098b50571d4b3b8",
        strip_prefix = "bazel-lib-0.11.1",
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v0.11.1.tar.gz",
    )
    maybe(
        http_archive,
        name = "aspect_rules_js",
        sha256 = "06dd11130f05df3e8b9aa8cc1b93577e88f540cd4ece8f00035109cc17dcf5ff",
        strip_prefix = "rules_js-0.8.0",
        url = "https://github.com/aspect-build/rules_js/archive/refs/tags/v0.8.0.tar.gz",
    )
    maybe(
        http_archive,
        name = "rules_nodejs",
        sha256 = "48146434180db3f5be9be0890d58cf3250cc81acc652a04816aea0c0d06cfbd9",
        strip_prefix = "rules_nodejs-cd48e24da0f44b9f49cb4b0254a8747b987970fe",
        url = "https://github.com/gregmagolan/rules_nodejs/archive/cd48e24da0f44b9f49cb4b0254a8747b987970fe.tar.gz",
    )
