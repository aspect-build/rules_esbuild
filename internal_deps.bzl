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
        sha256 = "8d71a578e4e1b6a54aea7598ebfbd8fc9e3be5da881ff9d2b80249577b933a40",
        strip_prefix = "bazel-lib-2.2.0",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v2.2.0/bazel-lib-v2.2.0.tar.gz",
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
