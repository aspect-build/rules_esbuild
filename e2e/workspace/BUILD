load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")
load("@bazel_skylib//rules:build_test.bzl", "build_test")

esbuild(
    name = "lib",
    srcs = ["main.js"],
    entry_point = "main.js",
)

build_test(
    name = "test",
    targets = [":lib"],
)
