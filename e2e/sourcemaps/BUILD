load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")
load("@bazel_skylib//rules:build_test.bzl", "build_test")

SRCS = [
    "main.js",
    "lib.js",
]

ENTRY = "main.js"

esbuild(
    name = "sourcemap-default",
    testonly = 1,
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-default.js",
)

build_test(
    name = "default",
    targets = [
        "sm-default.js",
        "sm-default.js.map",
    ],
)

esbuild(
    name = "sourcemap-falsy",
    testonly = 1,
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-falsy.js",
    sourcemap = False,
)

build_test(
    name = "falsy",
    targets = ["sm-falsy.js"],
)

esbuild(
    name = "sourcemap-none",
    testonly = 1,
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-none.js",
    sourcemap = None,
)

build_test(
    name = "none",
    targets = ["sm-none.js"],
)

esbuild(
    name = "sourcemap-linked",
    testonly = 1,
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-linked.js",
    sourcemap = "linked",
)

build_test(
    name = "linked",
    targets = [
        "sm-linked.js",
        "sm-linked.js.map",
    ],
)

esbuild(
    name = "sourcemap-external",
    testonly = 1,
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-external.js",
    sourcemap = "external",
)

build_test(
    name = "external",
    targets = [
        "sm-external.js",
        "sm-external.js.map",
    ],
)

esbuild(
    name = "sourcemap-inline",
    testonly = 1,
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-inline.js",
    sourcemap = "inline",
)

build_test(
    name = "inline",
    targets = ["sm-inline.js"],
)

esbuild(
    name = "sourcemap-both",
    testonly = 1,
    srcs = SRCS,
    entry_point = ENTRY,
    output = "sm-both.js",
    sourcemap = "both",
)

build_test(
    name = "both",
    targets = [
        "sm-both.js",
        "sm-both.js.map",
    ],
)
