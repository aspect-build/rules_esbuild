"esbuild rule"

load("@aspect_bazel_lib//lib:expand_make_vars.bzl", "expand_variables")
load("@aspect_bazel_lib//lib:copy_to_bin.bzl", "copy_file_to_bin_action", "copy_files_to_bin_actions")
load("@aspect_rules_js//js:libs.bzl", "js_lib_helpers")
load("@aspect_rules_js//js:providers.bzl", "JsInfo", "js_info")
load(":helpers.bzl", "desugar_entry_point_names", "filter_files", "write_args_file")

_ATTRS = {
    "args_file": attr.label(
        allow_single_file = True,
        mandatory = False,
        doc = "Internal use only",
    ),
    "define": attr.string_dict(
        default = {},
        doc = """A dict of global identifier replacements. Values are subject to $(location ...) expansion.
Example:
```python
esbuild(
name = "bundle",
define = {
"process.env.NODE_ENV": "production"
},
)
```

See https://esbuild.github.io/api/#define for more details
    """,
    ),
    "deps": attr.label_list(
        default = [],
        doc = "A list of direct dependencies that are required to build the bundle",
        providers = [JsInfo],
    ),
    "data": js_lib_helpers.JS_LIBRARY_DATA_ATTR,
    "entry_point": attr.label(
        allow_single_file = True,
        doc = """The bundle's entry point (e.g. your main.js or app.js or index.js)

This is a shortcut for the `entry_points` attribute with a single entry.
Specify either this attribute or `entry_point`, but not both.
""",
    ),
    "entry_points": attr.label_list(
        allow_files = True,
        doc = """The bundle's entry points (e.g. your main.js or app.js or index.js)

Specify either this attribute or `entry_point`, but not both.
""",
    ),
    "external": attr.string_list(
        default = [],
        doc = """A list of module names that are treated as external and not included in the resulting bundle

See https://esbuild.github.io/api/#external for more details
    """,
    ),
    "format": attr.string(
        values = ["iife", "cjs", "esm", ""],
        mandatory = False,
        doc = """The output format of the bundle, defaults to iife when platform is browser
and cjs when platform is node. If performing code splitting or multiple entry_points are specified, defaults to esm.

See https://esbuild.github.io/api/#format for more details
""",
    ),
    "launcher": attr.label(
        executable = True,
        doc = "Override the default esbuild wrapper, which is supplied by the esbuild toolchain",
        cfg = "exec",
    ),
    "max_threads": attr.int(
        mandatory = False,
        doc = """Sets the `GOMAXPROCS` variable to limit the number of threads that esbuild can run with.
This can be useful if running many esbuild rule invocations in parallel, which has the potential to cause slowdown.
For general use, leave this attribute unset.
    """,
    ),
    "metafile": attr.bool(
        default = False,
        doc = "If true, esbuild creates a metafile along with the output",
        mandatory = False,
    ),
    "minify": attr.bool(
        default = False,
        doc = """Minifies the bundle with the built in minification.
Removes whitespace, shortens identifieres and uses equivalent but shorter syntax.

Sets all --minify-* flags

See https://esbuild.github.io/api/#minify for more details
    """,
    ),
    "output": attr.output(
        mandatory = False,
        doc = "Name of the output file when bundling",
    ),
    "output_css": attr.output(
        mandatory = False,
        doc = """Declare a .css file will be output next to output bundle.

If your JS code contains import statements that import .css files, esbuild will place the
content in a file next to the main output file, which you'll need to declare. If your output
file is named 'foo.js', you should set this to 'foo.css'.""",
    ),
    "output_dir": attr.bool(
        default = False,
        doc = """If true, esbuild produces an output directory containing all output files""",
    ),
    "output_map": attr.output(
        mandatory = False,
        doc = "Name of the output source map when bundling",
    ),
    "platform": attr.string(
        default = "browser",
        values = ["node", "browser", "neutral", ""],
        doc = """The platform to bundle for.

See https://esbuild.github.io/api/#platform for more details
    """,
    ),
    "sourcemap": attr.string(
        values = ["linked", "external", "inline", "both"],
        mandatory = False,
        doc = """Defines where sourcemaps are output and how they are included in the bundle. If `linked`, a separate `.js.map` file is generated and referenced by the bundle. If `external`, a separate `.js.map` file is generated but not referenced by the bundle. If `inline`, a sourcemap is generated and its contents are inlined into the bundle (and no external sourcemap file is created). If `both`, a sourcemap is inlined and a `.js.map` file is created.

See https://esbuild.github.io/api/#sourcemap for more details
    """,
    ),
    "sources_content": attr.bool(
        mandatory = False,
        default = False,
        doc = """If False, omits the `sourcesContent` field from generated source maps

See https://esbuild.github.io/api/#sources-content for more details
    """,
    ),
    "splitting": attr.bool(
        default = False,
        doc = """If true, esbuild produces an output directory containing all the output files from code splitting for multiple entry points

See https://esbuild.github.io/api/#splitting and https://esbuild.github.io/api/#entry-points for more details
    """,
    ),
    "srcs": attr.label_list(
        allow_files = True,
        default = [],
        doc = """Source files to be made available to esbuild""",
    ),
    "target": attr.string(
        default = "es2015",
        doc = """Environment target (e.g. es2017, chrome58, firefox57, safari11, 
edge16, node10, esnext). Default es2015.

See https://esbuild.github.io/api/#target for more details
    """,
    ),
    "config": attr.label(
        mandatory = False,
        allow_single_file = True,
        doc = """Configuration file used for esbuild. Note that options set in this file may get overwritten.
        TODO: show how to write a config file that depends on plugins, similar to the esbuild_config macro in rules_nodejs.
    """,
    ),
}

def _bin_relative_path(ctx, file):
    prefix = ctx.bin_dir.path + "/"
    if file.path.startswith(prefix):
        return file.path[len(prefix):]

    # Since file.path is relative to execroot, go up with ".." starting from
    # ctx.bin_dir until we reach execroot, then join that with the file path.
    up = "/".join([".." for _ in ctx.bin_dir.path.split("/")])
    return up + "/" + file.path

def _esbuild_impl(ctx):
    node_toolinfo = ctx.toolchains["@rules_nodejs//nodejs:toolchain_type"].nodeinfo
    esbuild_toolinfo = ctx.toolchains["@aspect_rules_esbuild//esbuild:toolchain_type"].esbuildinfo

    entry_points = desugar_entry_point_names(ctx.file.entry_point, ctx.files.entry_points)
    entry_points_bin_copy = copy_files_to_bin_actions(ctx, entry_points)

    args = dict({
        "bundle": True,
        "define": dict([
            [
                k,
                expand_variables(ctx, ctx.expand_location(v), attribute_name = "define"),
            ]
            for k, v in ctx.attr.define.items()
        ]),
        # the entry point files to bundle
        "entryPoints": [_bin_relative_path(ctx, entry_point) for entry_point in entry_points_bin_copy],
        "external": ctx.attr.external,
        # by default the log level is "info" and includes an output file summary
        # under bazel this is slightly redundant and may lead to spammy logs
        # Also disable the log limit and show all logs
        "logLevel": "warning",
        "logLimit": 0,
        "metafile": ctx.attr.metafile,
        "platform": ctx.attr.platform,
        # Don't preserve symlinks since doing so breaks node_modules resolution
        # in the pnpm-style symlinked node_modules structure.
        # See https://pnpm.io/symlinked-node-modules-structure.
        # NB: esbuild will currently leave the sandbox and end up in the output
        # tree until symlink guards are created to prevent this.
        # See https://github.com/aspect-build/rules_esbuild/pull/32.
        "preserveSymlinks": False,
        "sourcesContent": ctx.attr.sources_content,
        "target": ctx.attr.target,
    })

    if ctx.attr.sourcemap:
        args.update({"sourcemap": ctx.attr.sourcemap})

    if ctx.attr.minify:
        args.update({"minify": True})
    else:
        # by default, esbuild will tree-shake "pure" functions
        # disable this unless also minifying
        args.update({"ignoreAnnotations": True})

    if ctx.attr.splitting:
        if not ctx.attr.output_dir:
            fail("output_dir must be set to True when splitting is set to True")
        args.update({
            "format": "esm",
            "splitting": True,
        })

    output_sources = []

    if ctx.attr.output_dir:
        js_out = ctx.actions.declare_directory("%s" % ctx.attr.name)
        output_sources.append(js_out)

        # disable the log limit and show all logs
        args.update({
            "outdir": _bin_relative_path(ctx, js_out),
        })
    else:
        js_out = ctx.outputs.output
        output_sources.append(js_out)

        js_out_map = ctx.outputs.output_map
        if ctx.attr.sourcemap and ctx.attr.sourcemap != "inline":
            if js_out_map == None:
                fail("output_map must be specified if sourcemap is not set to 'inline'")
            output_sources.append(js_out_map)

        if ctx.outputs.output_css:
            output_sources.append(ctx.outputs.output_css)

        if ctx.attr.format:
            args.update({"format": ctx.attr.format})

        args.update({"outfile": _bin_relative_path(ctx, js_out)})

    env = {
        "BAZEL_BINDIR": ctx.bin_dir.path,
        "ESBUILD_BINARY_PATH": "../../../" + esbuild_toolinfo.target_tool_path,
    }

    if ctx.attr.max_threads > 0:
        env["GOMAXPROCS"] = str(ctx.attr.max_threads)

    execution_requirements = {}
    if "no-remote-exec" in ctx.attr.tags:
        execution_requirements = {"no-remote-exec": "1"}

    # setup the args passed to the launcher
    launcher_args = ctx.actions.args()
    other_inputs = []

    args_file = write_args_file(ctx, args)
    other_inputs.append(args_file)
    launcher_args.add("--esbuild_args=%s" % _bin_relative_path(ctx, args_file))

    if ctx.attr.metafile:
        # add metafile
        meta_file = ctx.actions.declare_file("%s_metadata.json" % ctx.attr.name)
        output_sources.append(meta_file)
        launcher_args.add("--metafile=%s" % _bin_relative_path(ctx, meta_file))

    # add reference to the users args file, these are merged within the launcher
    if ctx.attr.args_file:
        # TODO: Copy this to bin?
        other_inputs.append(ctx.file.args_file)
        launcher_args.add("--user_args=%s" % _bin_relative_path(ctx, ctx.file.args_file))

    if ctx.attr.config:
        config_bin_copy = copy_file_to_bin_action(ctx, ctx.file.config)
        other_inputs.append(config_bin_copy)
        launcher_args.add("--config_file=%s" % _bin_relative_path(ctx, config_bin_copy))

    # stamp = ctx.attr.node_context_data[NodeContextInfo].stamp
    # if stamp:
    #     inputs.append(ctx.info_file)
    #     env["BAZEL_INFO_FILE"] = ctx.info_file.path

    #     inputs.append(ctx.version_file)
    #     env["BAZEL_VERSION_FILE"] = ctx.version_file.path

    input_sources = depset(
        copy_files_to_bin_actions(ctx, [
            file
            for file in ctx.files.srcs
            if not (file.path.endswith(".d.ts") or file.path.endswith(".tsbuildinfo"))
        ]) + entry_points_bin_copy + other_inputs + node_toolinfo.tool_files + esbuild_toolinfo.tool_files,
        transitive = [js_lib_helpers.gather_files_from_js_providers(
            targets = ctx.attr.srcs + ctx.attr.deps,
            include_transitive_sources = True,
            include_declarations = False,
            include_npm_linked_packages = True,
        )],
    )

    launcher = ctx.executable.launcher or esbuild_toolinfo.launcher.files_to_run
    ctx.actions.run(
        inputs = input_sources,
        outputs = output_sources,
        arguments = [launcher_args],
        progress_message = "%s Javascript %s [esbuild]" % ("Bundling" if not ctx.attr.output_dir else "Splitting", " ".join([_bin_relative_path(ctx, entry_point) for entry_point in entry_points])),
        execution_requirements = execution_requirements,
        mnemonic = "esbuild",
        env = env,
        executable = launcher,
    )

    npm_linked_packages = js_lib_helpers.gather_npm_linked_packages(
        srcs = ctx.attr.srcs,
        deps = [],
    )

    npm_package_store_deps = js_lib_helpers.gather_npm_package_store_deps(
        targets = ctx.attr.data,
    )

    output_sources_depset = depset(output_sources)

    runfiles = js_lib_helpers.gather_runfiles(
        ctx = ctx,
        sources = output_sources_depset,
        data = ctx.attr.data,
        # Since we're bundling, we don't propogate any transitive runfiles from dependencies
        deps = [],
    )

    return [
        DefaultInfo(
            files = output_sources_depset,
            runfiles = runfiles,
        ),
        js_info(
            npm_linked_package_files = npm_linked_packages.direct_files,
            npm_linked_packages = npm_linked_packages.direct,
            npm_package_store_deps = npm_package_store_deps,
            sources = output_sources_depset,
            # Since we're bundling, we don't propogate linked npm packages from dependencies since
            # they are bundled and the dependencies are dropped. If a subset of linked npm
            # dependencies are not bundled it is up the the user to re-specify these in `data` if
            # they are runtime dependencies to progagate to binary rules or `srcs` if they are to be
            # propagated to downstream build targets.
            transitive_npm_linked_package_files = npm_linked_packages.direct_files,
            transitive_npm_linked_packages = npm_linked_packages.direct,
            # Since we're bundling, we don't propogate any transitive sources from dependencies
            transitive_sources = output_sources_depset,
        ),
    ]

lib = struct(
    attrs = _ATTRS,
    implementation = _esbuild_impl,
    toolchains = [
        "@rules_nodejs//nodejs:toolchain_type",
        "@aspect_rules_esbuild//esbuild:toolchain_type",
    ],
)

esbuild_bundle = rule(
    implementation = _esbuild_impl,
    attrs = _ATTRS,
    toolchains = lib.toolchains,
    doc = """\
Runs the esbuild bundler under Bazel

For further information about esbuild, see https://esbuild.github.io/
""",
)
