load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")
load("@bazel_skylib//rules:build_test.bzl", "build_test")

esbuild(
    name = "bundle",
    srcs = ["index.js"],
    entry_point = "index.js",
)

build_test(
    name = "bundle_test",
    targets = [":bundle"],
)
