load("@bazel_skylib//rules:build_test.bzl", "build_test")
load("@aspect_rules_ts//ts:defs.bzl", "ts_project")
load("@aspect_rules_js//js:defs.bzl", "js_library")


def ts_library(name, srcs = [], deps = [], visibility = None):
    js_library(
        name = name,
        srcs = srcs,
        deps = deps,
        visibility = visibility,
    )

    # Use ts_project() + build_test() only to typecheck
    ts_project_name = name + "_test"
    ts_project(
        name = "__%s" % ts_project_name,
        srcs = srcs,
        deps = deps,
        declaration = True,
        emit_declaration_only = True,
        tsconfig = "//:tsconfig",
        tags = ["manual"],
        testonly = True,
        visibility = ["//visibility:private"],
    )
    build_test(
        name = ts_project_name,
        targets = [
            ":__%s" % ts_project_name,
        ],
    )