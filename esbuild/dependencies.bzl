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
        sha256 = "6d758a8f646ecee7a3e294fbe4386daafbe0e5966723009c290d493f227c390b",
        strip_prefix = "bazel-lib-2.7.7",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v2.7.7/bazel-lib-v2.7.7.tar.gz",
    )

    http_archive(
        name = "aspect_rules_js",
        sha256 = "7085e915cdba6f2dc0ce93bef59f5d040a539b510b840456b6ac7ccc2bee7886",
        strip_prefix = "rules_js-2.0.0-rc1",
        url = "https://github.com/aspect-build/rules_js/releases/download/v2.0.0-rc1/rules_js-v2.0.0-rc1.tar.gz",
    )

    http_archive(
        name = "rules_nodejs",
        sha256 = "dddd60acc3f2f30359bef502c9d788f67e33814b0ddd99aa27c5a15eb7a41b8c",
        strip_prefix = "rules_nodejs-6.1.0",
        url = "https://github.com/bazelbuild/rules_nodejs/releases/download/v6.1.0/rules_nodejs-v6.1.0.tar.gz",
    )
