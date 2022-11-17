load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")
load("@bazel_skylib//rules:build_test.bzl", "build_test")

SRCS = ["main.js", "lib.js"]
ENTRY = "main.js"

esbuild(
    name = "sourcemap-default",
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-default.js",
    testonly = 1,
)
build_test(
    name = "default",
    targets = ["sm-default.js", "sm-default.js.map"],
)

esbuild(
    name = "sourcemap-falsy",
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-falsy.js",
    sourcemap = False,
    testonly = 1,
)
build_test(
    name = "falsy",
    targets = ["sm-falsy.js"],
)

esbuild(
    name = "sourcemap-none",
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-none.js",
    sourcemap = None,
    testonly = 1,
)
build_test(
    name = "none",
    targets = ["sm-none.js"],
)

esbuild(
    name = "sourcemap-linked",
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-linked.js",
    sourcemap = "linked",
    testonly = 1,
)
build_test(
    name = "linked",
    targets = ["sm-linked.js", "sm-linked.js.map"],
)

esbuild(
    name = "sourcemap-external",
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-external.js",
    sourcemap = "external",
    testonly = 1,
)
build_test(
    name = "external",
    targets = ["sm-external.js", "sm-external.js.map"],
)

esbuild(
    name = "sourcemap-inline",
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-inline.js",
    sourcemap = "inline",
    testonly = 1,
)
build_test(
    name = "inline",
    targets = ["sm-inline.js"],
)

esbuild(
    name = "sourcemap-both",
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-both.js",
    sourcemap = "both",
    testonly = 1,
)
build_test(
    name = "both",
    targets = ["sm-both.js", "sm-both.js.map"],
)