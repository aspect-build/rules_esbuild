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
        sha256 = "f8ae724cd54c3284892ebaf5a308ed0760a18cc0cc73ff64e0325b7556437201",
        strip_prefix = "bazel-lib-0.9.4",
        url = "https://github.com/aspect-build/bazel-lib/archive/refs/tags/v0.9.4.tar.gz",
    )
    maybe(
        http_archive,
        name = "aspect_rules_js",
        sha256 = "3e64e87a7885f1f4ae21ffaa2dc512b9bc315ff8b6e6332c9ccd5b38d66e230b",
        strip_prefix = "rules_js-0.4.0",
        url = "https://github.com/aspect-build/rules_js/archive/refs/tags/v0.4.0.tar.gz",
    )
    maybe(
        http_archive,
        name = "rules_nodejs",
        sha256 = "1f9fca05f4643d15323c2dee12bd5581351873d45457f679f84d0fe0da6839b7",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.4.0/rules_nodejs-core-5.4.0.tar.gz"],
    )
