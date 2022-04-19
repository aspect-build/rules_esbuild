"Defines a trivial macro that invokes esbuild"

def esbuild_help(name, out):
    # Show how to call esbuild directly using the toolchain.
    native.genrule(
        name = name,
        srcs = [],
        # The result will be in bazel-bin/examples/macro/help
        outs = [out],
        cmd = "$(ESBUILD_BIN) --help > $@",
        toolchains = ["@esbuild14_toolchains//:resolved_toolchain"],
        tools = ["@esbuild14_toolchains//:resolved_toolchain"],
    )
