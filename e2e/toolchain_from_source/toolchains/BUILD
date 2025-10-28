load("@aspect_rules_esbuild//esbuild:toolchain.bzl", "esbuild_toolchain")

esbuild_toolchain(
    name = "toolchain",
    launcher = "//tools:launcher",
    # This target is defined by gazelle, see MODULE.bazel
    target_tool = "@com_github_evanw_esbuild//cmd/esbuild",
)

toolchain(
    name = "esbuild_binary_toolchain.registration",
    toolchain = ":toolchain",
    toolchain_type = "@aspect_rules_esbuild//esbuild:toolchain_type",
)
