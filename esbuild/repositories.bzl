"""Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies
"""

load("@aspect_rules_js//js:npm_import.bzl", "npm_import")
load("//esbuild/private:toolchains_repo.bzl", "PLATFORMS", "toolchains_repo")
load("//esbuild/private:versions.bzl", "TOOL_VERSIONS")

_DOC = "Fetch external tools needed for esbuild toolchain"
_ATTRS = {
    "esbuild_version": attr.string(mandatory = True, values = TOOL_VERSIONS.keys()),
    "platform": attr.string(mandatory = True, values = PLATFORMS.keys()),
    "url": attr.string(default = "https://registry.npmjs.org/esbuild-{platform}/-/esbuild-{platform}-{version}.tgz"),
}

def _esbuild_repo_impl(repository_ctx):
    esbuild = TOOL_VERSIONS[repository_ctx.attr.esbuild_version]
    integrity = esbuild[repository_ctx.attr.platform]
    url = repository_ctx.attr.url.format(
        platform = repository_ctx.attr.platform,
        version = repository_ctx.attr.esbuild_version,
    )
    repository_ctx.download_and_extract(
        url = url,
        integrity = integrity,
    )
    build_content = """#Generated by esbuild/repositories.bzl
load("@aspect_rules_esbuild//esbuild:toolchain.bzl", "esbuild_toolchain")
load("@aspect_rules_js//js:nodejs_binary.bzl", "nodejs_binary")

nodejs_binary(
    name = "launcher",
    entry_point = "@aspect_rules_esbuild//esbuild/private:launcher.js",
    data = ["@npm_esbuild-{version}"],
)
esbuild_toolchain(
    name = "esbuild_toolchain",
    launcher = ":launcher",
    target_tool = select({{
        "@bazel_tools//src/conditions:host_windows": "package/esbuild.exe",
        "//conditions:default": "package/bin/esbuild",
    }}),
)
""".format(version = repository_ctx.attr.esbuild_version)

    # Base BUILD file for this repository
    repository_ctx.file("BUILD.bazel", build_content)

esbuild_repositories = repository_rule(
    _esbuild_repo_impl,
    doc = _DOC,
    attrs = _ATTRS,
)

# Wrapper macro around everything above, this is the primary API
def esbuild_register_toolchains(name, esbuild_version, **kwargs):
    """Convenience macro for users which does typical setup.

    - create a repository for each built-in platform like "esbuild_linux-64" -
      this repository is lazily fetched when node is needed for that platform.
    - TODO: create a convenience repository for the host platform like "esbuild_host"
    - create a repository exposing toolchains for each platform like "esbuild_platforms"
    - register a toolchain pointing at each platform
    Users can avoid this macro and do these steps themselves, if they want more control.
    Args:
        name: base name for all created repos, like "esbuild0_14"
        esbuild_version: a supported version like "0.14.36"
        **kwargs: passed to each node_repositories call
    """
    if esbuild_version not in TOOL_VERSIONS.keys():
        fail("""\
esbuild version {} is not currently mirrored into rules_esbuild.
Please instead choose one of these available versions: {}
Or, make a PR to the repo running /scripts/mirror_release.sh to add the newest version.
If you need custom versions, please file an issue.""".format(esbuild_version, TOOL_VERSIONS.keys()))
    for platform in PLATFORMS.keys():
        esbuild_repositories(
            name = name + "_" + platform,
            esbuild_version = esbuild_version,
            platform = platform,
            **kwargs
        )
        native.register_toolchains("@%s_toolchains//:%s_toolchain" % (name, platform))

    toolchains_repo(
        name = name + "_toolchains",
        user_repository_name = name,
    )

    npm_import(
        integrity = TOOL_VERSIONS[esbuild_version]["npm"],
        package = "esbuild",
        version = esbuild_version,
    )
