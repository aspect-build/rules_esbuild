load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")
load("@bazel_skylib//rules:build_test.bzl", "build_test")

esbuild(
    name = "bundle",
    entry_point = "index.js",
)

# A location expansion such as $(execpath ...) can bake a real, config-specific
# path into the action's args-file content, so this target must not advertise
# supports-path-mapping. See test.sh.
esbuild(
    name = "bundle_with_location_expansion",
    srcs = ["index.js"],
    define = {"__PATH__": "'$(execpath index.js)'"},
    entry_point = "index.js",
)

# Gives the `bazel test //...` step in CI something to run; the actual test
# assertions live in test.sh, which is run as a separate CI step.
build_test(
    name = "bundle_test",
    targets = [
        ":bundle",
        ":bundle_with_location_expansion",
    ],
)
