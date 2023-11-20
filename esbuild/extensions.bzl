"extensions for bzlmod"

load(":repositories.bzl", "DEFAULT_ESBUILD_REPOSITORY", "esbuild_register_toolchains")

esbuild_toolchain = tag_class(attrs = {
    "name": attr.string(
        doc = "Base name for generated repositories",
        default = DEFAULT_ESBUILD_REPOSITORY,
    ),
    "esbuild_version": attr.string(doc = "Explicit version of esbuild."),
    # TODO: support this variant
    # "esbuild_version_from": attr.string(doc = "Location of package.json which may have a version for @esbuild/core."),
})

def _toolchain_extension(module_ctx):
    registrations = {}
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.name != DEFAULT_ESBUILD_REPOSITORY and not mod.is_root:
                fail("Only the root module may provide a name for the esbuild toolchain.")

            if toolchain.name in registrations.keys():
                if toolchain.name == DEFAULT_ESBUILD_REPOSITORY:
                    # Prioritize the root-most registration of the default esbuild toolchain version and
                    # ignore any further registrations (modules are processed breadth-first)
                    continue
                if toolchain.esbuild_version == registrations[toolchain.name]:
                    # No problem to register a matching toolchain twice
                    continue
                fail("Multiple conflicting toolchains declared for name {} ({} and {}".format(
                    toolchain.name,
                    toolchain.esbuild_version,
                    registrations[toolchain.name],
                ))
            else:
                registrations[toolchain.name] = toolchain.esbuild_version
    for name, esbuild_version in registrations.items():
        esbuild_register_toolchains(
            name = name,
            esbuild_version = esbuild_version,
            register = False,
        )

esbuild = module_extension(
    implementation = _toolchain_extension,
    tag_classes = {"toolchain": esbuild_toolchain},
)
