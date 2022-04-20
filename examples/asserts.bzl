"Helpers for making test assertions"

load("@aspect_bazel_lib//lib:write_source_files.bzl", _write_source_files = "write_source_files")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

def assert_contains(name, actual, expected):
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

    native.sh_test(
        name = name,
        srcs = ["test.sh"],
        args = ["$(rootpath %s)" % actual],
        data = [actual],
    )

# esbuild's outputs include references to the source files in comments.
# When those sources are generated files, their paths include the bazel platform.
# One-liner to replace e.g. darwin-fastbuild with a placeholder.
STRIP_PLATFORM = "sed 's/$(TARGET_CPU)-$(COMPILATION_MODE)/[platform]/' <$< >$@"

def write_source_files(name, files, cmd = STRIP_PLATFORM, **kwargs):
    """Wrapper for write_source_files: each file's content is modified by replacing the current build's output platform (e.g. darwin-fastbuild) with a constant "[platform]".

    Args:
        name: Name of the executable target that creates or updates the source file
        files: A dict where the keys are source files or folders to write to and the values are labels pointing to the desired content.
            Sources must be within the same bazel package as the target.
        cmd: A one-liner suitable for use in a genrule, using make variables for a single input and output file (`$<` and `$@`).
        **kwargs: Additional attributes for write_source_files
    """

    stripped = {}
    for k, v in files.items():
        stripped[k] = v + ".stripped"
        native.genrule(
            name = "_{}_{}".format(name, v),
            srcs = [v],
            outs = [stripped[k]],
            cmd = STRIP_PLATFORM,
        )

    _write_source_files(
        name = name,
        files = stripped,
    )
