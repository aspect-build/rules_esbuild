load("@aspect_bazel_lib//lib:testing.bzl", "assert_contains")
load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")

SRCS = [
    "main.js",
    "lib.js",
]

ENTRY = "main.js"

esbuild(
    name = "bundle-true",
    testonly = 1,
    srcs = SRCS,
    entry_point = ENTRY,
    output = "bundle-true.js",
)

assert_contains(
    name = "bundle-true_test",
    actual = ":bundle-true.js",
    expected = "ANSWER = 42",
)

esbuild(
    name = "bundle-false",
    testonly = 1,
    srcs = SRCS,
    bundle = False,
    entry_point = ENTRY,
    output = "bundle-false.js",
)

assert_contains(
    name = "bundle-false_test",
    actual = ":bundle-false.js",
    expected = "from \"./lib\"",
)
