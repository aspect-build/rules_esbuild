"extensions for bzlmod"

load(":repositories.bzl", "esbuild_register_toolchains")

esbuild_toolchain = tag_class(attrs = {
    "name": attr.string(doc = "Base name for generated repositories"),
    "esbuild_version": attr.string(doc = "Explicit version of esbuild."),
    # TODO: support this variant
    # "esbuild_version_from": attr.string(doc = "Location of package.json which may have a version for @esbuild/core."),
})

def _toolchain_extension(module_ctx):
    registrations = {}
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.name in registrations.keys():
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
