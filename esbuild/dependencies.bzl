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
        sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "aspect_bazel_lib",
        sha256 = "79381b0975ba7d2d5653239e5bab12cf54d89b10217fe771b8edd95047a2e44b",
        strip_prefix = "bazel-lib-1.12.1",
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v1.12.1.tar.gz",
    )

    maybe(
        http_archive,
        name = "aspect_rules_js",
        sha256 = "9d80f28eb59df0486cc1e8e82868e97d8167429ea309a7ae96dfac64ff73275b",
        strip_prefix = "rules_js-1.4.0",
        url = "https://github.com/aspect-build/rules_js/archive/refs/tags/v1.4.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_nodejs",
        sha256 = "bce105e7a3d2a3c5eb90dcd6436544bf11f82e97073fb29e4090321ba2b84d8f",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.6.0/rules_nodejs-core-5.6.0.tar.gz"],
    )
