"""Starlark helper to fetch rules_esbuild dependencies.

Should be replaced by bzlmod for users of Bazel 6.0 and above.
"""

load("//esbuild/private:maybe.bzl", http_archive = "maybe_http_archive")

def rules_esbuild_dependencies():
    http_archive(
        name = "bazel_skylib",
        sha256 = "b8a1527901774180afc798aeb28c4634bdccf19c4d98e7bdd1ce79d1fe9aaad7",
        urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz"],
    )

    http_archive(
        name = "aspect_bazel_lib",
        sha256 = "262e3d6693cdc16dd43880785cdae13c64e6a3f63f75b1993c716295093d117f",
        strip_prefix = "bazel-lib-1.38.1",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v1.38.1/bazel-lib-v1.38.1.tar.gz",
    )

    http_archive(
        name = "aspect_rules_js",
        sha256 = "d9ceb89e97bb5ad53b278148e01a77a3e9100db272ce4ebdcd59889d26b9076e",
        strip_prefix = "rules_js-1.34.0",
        url = "https://github.com/aspect-build/rules_js/releases/download/v1.34.0/rules_js-v1.34.0.tar.gz",
    )

    http_archive(
        name = "rules_nodejs",
        sha256 = "764a3b3757bb8c3c6a02ba3344731a3d71e558220adcb0cf7e43c9bba2c37ba8",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.8.2/rules_nodejs-core-5.8.2.tar.gz"],
    )
