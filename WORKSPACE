# Declare the local Bazel workspace.
workspace(
    # see https://docs.bazel.build/versions/main/skylark/deploying.html#workspace
    name = "aspect_rules_esbuild",
)

load(":internal_deps.bzl", "rules_esbuild_internal_deps")

# Fetch deps needed only locally for development
rules_esbuild_internal_deps()

load("//esbuild:dependencies.bzl", "rules_esbuild_dependencies")

# Fetch dependencies which users need as well
rules_esbuild_dependencies()

load("@aspect_rules_js//js:repositories.bzl", "rules_js_dependencies")

rules_js_dependencies()

load("@aspect_bazel_lib//lib:repositories.bzl", "DEFAULT_YQ_VERSION", "aspect_bazel_lib_dependencies", "register_coreutils_toolchains", "register_yq_toolchains")

aspect_bazel_lib_dependencies()

register_coreutils_toolchains()

register_yq_toolchains(
    version = DEFAULT_YQ_VERSION,
)

load("@rules_nodejs//nodejs:repositories.bzl", "nodejs_register_toolchains")

nodejs_register_toolchains(
    name = "node16",
    node_version = "16.9.0",
)

load("//esbuild:repositories.bzl", "esbuild_register_toolchains")

esbuild_register_toolchains(
    name = "esbuild19",
    esbuild_version = "0.19.9",
)

# Install additional packages to test esbuild plugins
load("@aspect_rules_js//npm:npm_import.bzl", "npm_translate_lock")

npm_translate_lock(
    name = "esbuild_plugins",
    pnpm_lock = "//examples/plugins:pnpm-lock.yaml",
)

load("@esbuild_plugins//:repositories.bzl", _esbuild_plugin_repositories = "npm_repositories")

_esbuild_plugin_repositories()

# For running our own unit tests
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

############################################
# Stardoc
load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

load("@io_bazel_stardoc//:deps.bzl", "stardoc_external_deps")

stardoc_external_deps()

load("@stardoc_maven//:defs.bzl", stardoc_pinned_maven_install = "pinned_maven_install")

stardoc_pinned_maven_install()

# Buildifier
load("@buildifier_prebuilt//:deps.bzl", "buildifier_prebuilt_deps")

buildifier_prebuilt_deps()

load("@buildifier_prebuilt//:defs.bzl", "buildifier_prebuilt_register_toolchains")

buildifier_prebuilt_register_toolchains()
