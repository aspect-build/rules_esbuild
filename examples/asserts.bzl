"Helpers for making test assertions"

load("@bazel_skylib//rules:write_file.bzl", "write_file")

def assert_contains(name, actual, expected, path = None):
    """Generates a test target which fails if the file doesn't contain the string.

    Args:
        name: target to create
        actual: a file
        expected: a string which should appear in the file
    """

    write_file(
        name = "_" + name,
        out = "test.sh",
        content = [
            "#!/usr/bin/env bash",
            "set -o errexit",
            "grep --fixed-strings '%s' $1" % expected,
        ],
    )

    # Passing "actual" into the data attribute of sh_binary does not build when splitting is specified
    native.sh_library(
        name = "%s_lib" % name,
        data = [actual]
    )

    native.sh_test(
        name = name,
        srcs = ["test.sh"],
        args = ["$(rootpath %s)" % actual] if path == None else [path],
        deps = [":%s_lib" % name],
        data = [actual],
    )
