"""Starlark helper to fetch rules_esbuild dependencies.

Should be replaced by bzlmod for users of Bazel 6.0 and above.
"""

load("//esbuild/private:maybe.bzl", http_archive = "maybe_http_archive")

def rules_esbuild_dependencies():
    http_archive(
        name = "bazel_skylib",
        sha256 = "cd55a062e763b9349921f0f5db8c3933288dc8ba4f76dd9416aac68acee3cb94",
        urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/1.5.0/bazel-skylib-1.5.0.tar.gz"],
    )

    http_archive(
        name = "aspect_bazel_lib",
        sha256 = "5e9588d8407a576771f1e0d8956f541f78610f1b6e4cca29af2a096fccfe3b24",
        strip_prefix = "bazel-lib-1.39.1",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v1.39.1/bazel-lib-v1.39.1.tar.gz",
    )

    http_archive(
        name = "aspect_rules_js",
        sha256 = "76a04ef2120ee00231d85d1ff012ede23963733339ad8db81f590791a031f643",
        strip_prefix = "rules_js-1.34.1",
        url = "https://github.com/aspect-build/rules_js/releases/download/v1.34.1/rules_js-v1.34.1.tar.gz",
    )

    http_archive(
        name = "rules_nodejs",
        sha256 = "8fc8e300cb67b89ceebd5b8ba6896ff273c84f6099fc88d23f24e7102319d8fd",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.8.4/rules_nodejs-core-5.8.4.tar.gz"],
    )
