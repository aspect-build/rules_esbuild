load("@aspect_bazel_lib//lib:copy_to_bin.bzl", "copy_to_bin")
load("//:ts_library.bzl", "ts_library")
load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")

copy_to_bin(
    name = "tsconfig",
    srcs = ["tsconfig.json"],
    visibility = ["//:__subpackages__"],
)

ts_library(
    name = "index",
    srcs = ["index.ts"],
    deps = ["//dep"],
)

esbuild(
    name = "bundle",
    entry_point = "index.ts",
    splitting = True,
    deps = [":index"],
    data = [":tsconfig"],
)
