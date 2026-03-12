"Helpers for making test assertions"

load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@rules_shell//shell:sh_test.bzl", "sh_test")

def assert_contains(name, actual, expected, file = None):
    """Generates a test target which fails if a file doesn't contain the string.

    Args:
        name: target to create
        actual: a file label, or (when `file` is set) a target whose runfiles contain `file`
        expected: a string which should appear in the file
        file: optional path within `actual`'s runfiles to search instead of `actual` itself.
            Use this to assert on a file inside a TreeArtifact output.
    """

    if file:
        script = [
            "#!/usr/bin/env bash",
            "set -o errexit",
            "root=\"${TEST_SRCDIR:-$RUNFILES_DIR}\"",
            "found=$(find \"$root\" -path '*/%s' -print -quit)" % file,
            "if [ -z \"$found\" ]; then",
            "  echo \"expected file '%s' not found in runfiles ($root)\" >&2" % file,
            "  echo \"contents:\" >&2",
            "  find \"$root\" >&2 || true",
            "  exit 1",
            "fi",
            "grep --fixed-strings '%s' \"$found\"" % expected,
        ]
        args = []
    else:
        script = [
            "#!/usr/bin/env bash",
            "set -o errexit",
            "grep --fixed-strings '%s' $1" % expected,
        ]
        args = ["$(rootpath %s)" % actual]

    write_file(
        name = "_" + name,
        out = name + "_test.sh",
        content = script,
    )

    sh_test(
        name = name,
        srcs = [name + "_test.sh"],
        args = args,
        data = [actual],
    )
