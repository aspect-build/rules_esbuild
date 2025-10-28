load("@aspect_bazel_lib//lib:write_source_files.bzl", "write_source_files")
load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")

esbuild(
    name = "bundle",
    srcs = ["index.js"],
    entry_point = "index.js",
    output = "_bundle.js",
)

write_source_files(
    name = "bundle.checked_in",
    files = {
        "bundle.js": ":_bundle.js",
        "bundle.js.map": ":_bundle.js.map",
    },
)
