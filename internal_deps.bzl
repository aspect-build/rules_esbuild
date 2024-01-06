"""Our "development" dependencies

Users should *not* need to install these. If users see a load()
statement from these, that's a bug in our distribution.
"""

# buildifier: disable=bzl-visibility
load("//esbuild/private:maybe.bzl", http_archive = "maybe_http_archive")

def rules_esbuild_internal_deps():
    "Fetch deps needed for local development"

    # opt-in to 2.0 without forcing users to do so
    http_archive(
        name = "aspect_bazel_lib",
        sha256 = "a9ea6902c860918bd6928114efbc6ea2093df006af66459c9ac1637f9dd08f6a",
        strip_prefix = "bazel-lib-2.1.2",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v2.1.2/bazel-lib-v2.1.2.tar.gz",
    )

    http_archive(
        name = "io_bazel_rules_go",
        sha256 = "7c76d6236b28ff695aa28cf35f95de317a9472fd1fb14ac797c9bf684f09b37c",
        urls = ["https://github.com/bazelbuild/rules_go/releases/download/v0.44.2/rules_go-v0.44.2.zip"],
    )

    http_archive(
        name = "bazel_gazelle",
        sha256 = "32938bda16e6700063035479063d9d24c60eda8d79fd4739563f50d331cb3209",
        urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.35.0/bazel-gazelle-v0.35.0.tar.gz"],
    )

    http_archive(
        name = "bazel_skylib_gazelle_plugin",
        sha256 = "747addf3f508186234f6232674dd7786743efb8c68619aece5fb0cac97b8f415",
        urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/1.5.0/bazel-skylib-gazelle-plugin-1.5.0.tar.gz"],
    )

    http_archive(
        name = "io_bazel_stardoc",
        sha256 = "62bd2e60216b7a6fec3ac79341aa201e0956477e7c8f6ccc286f279ad1d96432",
        urls = ["https://github.com/bazelbuild/stardoc/releases/download/0.6.2/stardoc-0.6.2.tar.gz"],
    )

    http_archive(
        name = "buildifier_prebuilt",
        sha256 = "8ada9d88e51ebf5a1fdff37d75ed41d51f5e677cdbeafb0a22dda54747d6e07e",
        strip_prefix = "buildifier-prebuilt-6.4.0",
        urls = ["http://github.com/keith/buildifier-prebuilt/archive/6.4.0.tar.gz"],
    )
