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
        sha256 = "1cbbf62315d303c8083d5019a4657623d4f58e925fb51bdc8a41bad4a131f5c9",
        strip_prefix = "bazel-lib-1.8.1",
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v1.8.1.tar.gz",
    )

    maybe(
        http_archive,
        name = "aspect_rules_js",
        sha256 = "a6d31c98f30eb503e836201d723b3164c5e07ba34553d260f71720a819d8ba4c",
        strip_prefix = "rules_js-1.0.0-rc.2",
        url = "https://github.com/aspect-build/rules_js/archive/refs/tags/v1.0.0-rc.2.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_nodejs",
        sha256 = "4d48998e3fa1e03c684e6bdf7ac98051232c7486bfa412e5b5475bbaec7bb257",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.5.0/rules_nodejs-core-5.5.0.tar.gz"],
    )
