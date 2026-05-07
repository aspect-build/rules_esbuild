"""Analysis tests asserting that esbuild(srcs, deps) are not forwarded in
the providers of an esbuild() bundle.

When `bundle = True`, esbuild merges the JsInfo / NpmPackageStoreInfo of
its `srcs` and `deps` into the bundle output. Those inputs must NOT
appear in the output JsInfo (otherwise consumers of the bundle would
double-count source files that are already inlined in the bundle).

Runfiles for `data` *should* still be forwarded — those are runtime
files esbuild does not understand and cannot bundle.
"""

load("@aspect_rules_js//js:providers.bzl", "JsInfo")
load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")

def _basenames(depset_or_list):
    files = depset_or_list.to_list() if hasattr(depset_or_list, "to_list") else depset_or_list
    return sorted([f.basename for f in files])

def _bundle_jsinfo_excludes_srcs_deps_test_impl(ctx):
    env = analysistest.begin(ctx)
    target = analysistest.target_under_test(env)

    js_info = target[JsInfo]

    transitive_sources = _basenames(js_info.transitive_sources)
    asserts.false(
        env,
        "lib_src.js" in transitive_sources,
        "esbuild(deps) src should not be forwarded in JsInfo.transitive_sources, but found: {}".format(transitive_sources),
    )
    asserts.false(
        env,
        "direct_src.js" in transitive_sources,
        "esbuild(srcs) src should not be forwarded in JsInfo.transitive_sources, but found: {}".format(transitive_sources),
    )

    asserts.equals(
        env,
        [],
        js_info.transitive_types.to_list(),
        "JsInfo.transitive_types should be empty for a bundling esbuild() target",
    )

    # `npm_package_store_infos` should only carry forward what came in via `data`
    # (which esbuild does not understand), not via `srcs` or `deps` (which are
    # bundled into the output).
    asserts.equals(
        env,
        [],
        js_info.npm_package_store_infos.to_list(),
        "JsInfo.npm_package_store_infos should not include anything from srcs/deps",
    )

    sources = _basenames(js_info.sources)
    asserts.true(
        env,
        "bundle_for_provider_test.js" in sources,
        "JsInfo.sources should contain the bundle output, got: {}".format(sources),
    )
    asserts.false(
        env,
        "lib_src.js" in sources,
        "esbuild(deps) src should not appear in JsInfo.sources, got: {}".format(sources),
    )
    asserts.false(
        env,
        "direct_src.js" in sources,
        "esbuild(srcs) src should not appear in JsInfo.sources, got: {}".format(sources),
    )

    return analysistest.end(env)

bundle_jsinfo_excludes_srcs_deps_test = analysistest.make(
    _bundle_jsinfo_excludes_srcs_deps_test_impl,
)

def _bundle_runfiles_include_data_test_impl(ctx):
    env = analysistest.begin(ctx)
    target = analysistest.target_under_test(env)

    runfiles = _basenames(target[DefaultInfo].default_runfiles.files)
    asserts.true(
        env,
        "pig.txt" in runfiles,
        "esbuild(data) should be forwarded as runfiles, got: {}".format(runfiles),
    )
    asserts.true(
        env,
        "cow.txt" in runfiles,
        "data attached to a dep (js_library.data) must be forwarded in the bundle's runfiles, got: {}".format(runfiles),
    )

    return analysistest.end(env)

bundle_runfiles_include_data_test = analysistest.make(
    _bundle_runfiles_include_data_test_impl,
)
