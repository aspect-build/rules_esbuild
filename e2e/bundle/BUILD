load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")
load("@bazel_skylib//rules:build_test.bzl", "build_test")

SRCS = ["main.js", "lib.js"]
ENTRY = "main.js"

esbuild(
    name = "bundle-true",
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-default.js",
    testonly = 1,
)
build_test(
    name = "true",
    targets = [":bundle-true"],
)

esbuild(
    name = "bundle-false",
    srcs = SRCS,
    entry_point = ENTRY,
    bundle = False,
    output_dir = ".",
    testonly = 1,
)
build_test(
    name = "false",
    targets = [":bundle-false"],
)
