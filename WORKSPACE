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

load("@aspect_bazel_lib//lib:repositories.bzl", "DEFAULT_YQ_VERSION", "aspect_bazel_lib_dependencies", "register_yq_toolchains")

aspect_bazel_lib_dependencies(override_local_config_platform = True)

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
    name = "esbuild14",
    esbuild_version = "0.17.10",
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
# Gazelle, for generating bzl_library targets
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.19.3")

gazelle_dependencies()

# Buildifier
load("@buildifier_prebuilt//:deps.bzl", "buildifier_prebuilt_deps")

buildifier_prebuilt_deps()

load("@buildifier_prebuilt//:defs.bzl", "buildifier_prebuilt_register_toolchains")

buildifier_prebuilt_register_toolchains()
