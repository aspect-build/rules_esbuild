"# esbuild rule"

load("@aspect_bazel_lib//lib:copy_to_bin.bzl", "COPY_FILE_TO_BIN_TOOLCHAINS", "copy_file_to_bin_action", "copy_files_to_bin_actions")
load("@aspect_bazel_lib//lib:expand_make_vars.bzl", "expand_variables")
load("@aspect_rules_js//js:libs.bzl", "js_lib_constants", "js_lib_helpers")
load("@aspect_rules_js//js:providers.bzl", "JsInfo", "js_info")
load(":helpers.bzl", "desugar_entry_point_names", "write_args_file")

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
    "data": attr.label_list(
        doc = """Runtime dependencies to include in binaries/tests that depend on this target.

Follows the same semantics as `js_library` `data` attribute. See
https://docs.aspect.build/rulesets/aspect_rules_js/docs/js_library#data for more info.
""",
        allow_files = True,
    ),
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
    "target": attr.string_list(
        default = ["es2015"],
        doc = """Environment target (e.g. es2017, chrome58, firefox57, safari11, 
edge16, node10, esnext). Default es2015.

See https://esbuild.github.io/api/#target for more details
    """,
    ),
    "bundle": attr.bool(
        default = True,
        doc = """If true, esbuild will bundle the input files, inlining their dependencies recursively""",
    ),
    "config": attr.label(
        mandatory = False,
        allow_single_file = True,
        doc = """Configuration file used for esbuild. Note that options set in this file may get overwritten. If you formerly used `args` from rules_nodejs' npm package `@bazel/esbuild`, replace it with this attribute.
        TODO: show how to write a config file that depends on plugins, similar to the esbuild_config macro in rules_nodejs.
    """,
    ),
    "tsconfig": attr.label(
        mandatory = True,
        allow_single_file = True,
        doc = """TypeScript configuration file used by esbuild. Default to an empty file with no configuration.
        
        See https://esbuild.github.io/api/#tsconfig for more details
    """,
    ),
    "bazel_sandbox_plugin": attr.bool(
        default = True,
        doc = """If true, a custom bazel-sandbox plugin will be enabled that prevents esbuild from leaving the Bazel sandbox.
        See https://github.com/aspect-build/rules_esbuild/pull/160 for more info.""",
    ),
    "esbuild_log_level": attr.string(
        default = "warning",
        doc = """Set the logging level of esbuild.

        We set a default of "warmning" since the esbuild default of "info" includes
        an output file summary which is slightly redundant under Bazel and may lead
        to spammy `bazel build` output.

        See https://esbuild.github.io/api/#log-level for more details.
        """,
        values = ["silent", "error", "warning", "info", "debug", "verbose"],
    ),
    "js_log_level": attr.string(
        default = "error",
        doc = """Set the logging level for js_binary launcher and the JavaScript bazel-sandbox plugin.

        Log levels: {}""".format(", ".join(js_lib_constants.LOG_LEVELS.keys())),
        values = js_lib_constants.LOG_LEVELS.keys(),
    ),
    "node_toolchain": attr.label(
        doc = """The Node.js toolchain to use for this target.

        See https://bazelbuild.github.io/rules_nodejs/Toolchains.html

        Typically this is left unset so that Bazel automatically selects the right Node.js toolchain
        for the target platform. See https://bazel.build/extending/toolchains#toolchain-resolution
        for more information.
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
    if ctx.attr.node_toolchain:
        node_toolchain = ctx.attr.node_toolchain[platform_common.ToolchainInfo]
    else:
        node_toolchain = ctx.toolchains["@rules_nodejs//nodejs:toolchain_type"]

    node_toolinfo = node_toolchain.nodeinfo
    esbuild_toolinfo = ctx.toolchains["@aspect_rules_esbuild//esbuild:toolchain_type"].esbuildinfo

    entry_points = desugar_entry_point_names(ctx.file.entry_point, ctx.files.entry_points)
    entry_points_bin_copy = copy_files_to_bin_actions(ctx, entry_points)
    tsconfig_bin_copy = copy_file_to_bin_action(ctx, ctx.file.tsconfig)

    args = dict({
        "bundle": ctx.attr.bundle,
        "define": dict([
            [
                k,
                expand_variables(ctx, ctx.expand_location(v), attribute_name = "define"),
            ]
            for k, v in ctx.attr.define.items()
        ]),
        "entryPoints": [_bin_relative_path(ctx, entry_point) for entry_point in entry_points_bin_copy],
        "external": ctx.attr.external,
        "logLevel": ctx.attr.esbuild_log_level,
        # Disable the log limit and show all logs
        "logLimit": 0,
        "tsconfig": _bin_relative_path(ctx, tsconfig_bin_copy),
        "metafile": ctx.attr.metafile,
        "platform": ctx.attr.platform,
        # Don't preserve symlinks since doing so breaks node_modules resolution
        # in the pnpm-style symlinked node_modules structure.
        # See https://pnpm.io/symlinked-node-modules-structure.
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
        if ctx.attr.format and ctx.attr.format != "esm":
            fail("only format of type 'esm' supported when splitting is set to True")

        args.update({
            "format": "esm",
            "splitting": True,
        })

    if ctx.attr.format:
        args.update({"format": ctx.attr.format})

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

        args.update({"outfile": _bin_relative_path(ctx, js_out)})

    env = {
        "BAZEL_BINDIR": ctx.bin_dir.path,
        "ESBUILD_BINARY_PATH": esbuild_toolinfo.target_tool_path,
    }

    if ctx.attr.bazel_sandbox_plugin:
        env["ESBUILD_BAZEL_SANDBOX_PLUGIN"] = "1"

    if ctx.attr.max_threads > 0:
        env["GOMAXPROCS"] = str(ctx.attr.max_threads)

    for log_level_env in js_lib_helpers.envs_for_log_level(ctx.attr.js_log_level):
        env[log_level_env] = "1"

    execution_requirements = {}
    if "no-remote-exec" in ctx.attr.tags:
        execution_requirements = {"no-remote-exec": "1"}

    # setup the args passed to the launcher
    launcher_args = ctx.actions.args()
    other_inputs = []
    config_deps = []

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
        config_deps.append(ctx.attr.config)
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
        ]) + entry_points_bin_copy + [tsconfig_bin_copy] + other_inputs + node_toolinfo.tool_files + esbuild_toolinfo.tool_files,
        transitive = [js_lib_helpers.gather_files_from_js_infos(
            targets = ctx.attr.srcs + ctx.attr.deps + config_deps,
            include_sources = True,
            include_types = False,
            include_transitive_sources = True,
            include_transitive_types = False,
            include_npm_sources = True,
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
        use_default_shell_env = True,
        executable = launcher,
    )

    output_sources_depset = depset(output_sources)

    if ctx.attr.bundle:
        # When bundling don't propogate any transitive sources or declarations since sources
        # are typically bundled into the output.
        transitive_sources = output_sources_depset
        transitive_types = depset()

        # If a subset of linked npm dependencies are not bundled, it is up to the user to re-specify
        # these in `data` if they are runtime dependencies to progagate to binary rules or `srcs` if
        # they are to be propagated to downstream build targets.
        npm_sources = js_lib_helpers.gather_npm_sources(
            srcs = ctx.attr.srcs,
            deps = [],
        )
        npm_package_store_infos = js_lib_helpers.gather_npm_package_store_infos(
            targets = ctx.attr.data,
        )
        runfiles = js_lib_helpers.gather_runfiles(
            ctx = ctx,
            sources = output_sources_depset,
            data = ctx.attr.data,
            deps = [],  # when bundling, don't propogate any transitive runfiles from dependencies
        )
    else:
        # If we're not bundling then include all transitive files
        transitive_sources = js_lib_helpers.gather_transitive_sources(
            sources = output_sources,
            targets = ctx.attr.srcs + ctx.attr.deps,
        )
        transitive_types = js_lib_helpers.gather_transitive_types(
            types = [],
            targets = ctx.attr.srcs + ctx.attr.deps,
        )
        npm_sources = js_lib_helpers.gather_npm_sources(
            srcs = ctx.attr.srcs,
            deps = ctx.attr.deps,
        )
        npm_package_store_infos = js_lib_helpers.gather_npm_package_store_infos(
            targets = ctx.attr.srcs + ctx.attr.data + ctx.attr.deps,
        )
        runfiles = js_lib_helpers.gather_runfiles(
            ctx = ctx,
            sources = transitive_sources,
            data = ctx.attr.data,
            deps = ctx.attr.srcs + ctx.attr.deps,
        )

    return [
        DefaultInfo(
            files = output_sources_depset,
            runfiles = runfiles,
        ),
        js_info(
            target = ctx.label,
            sources = output_sources_depset,
            types = depset(),  # esbuild does not emit types directly
            transitive_sources = transitive_sources,
            transitive_types = transitive_types,
            npm_sources = npm_sources,
            npm_package_store_infos = npm_package_store_infos,
        ),
    ]

lib = struct(
    attrs = _ATTRS,
    implementation = _esbuild_impl,
    toolchains = [
        "@rules_nodejs//nodejs:toolchain_type",
        "@aspect_rules_esbuild//esbuild:toolchain_type",
    ] + COPY_FILE_TO_BIN_TOOLCHAINS,
)

esbuild_bundle = rule(
    implementation = _esbuild_impl,
    attrs = _ATTRS,
    toolchains = lib.toolchains,
    doc = """\
Runs the esbuild bundler under Bazel

For further information about esbuild, see https://esbuild.github.io/

Note: to prevent esbuild from following symlinks and leaving the bazel sandbox, a custom `bazel-sandbox` resolver plugin is used in this rule. See https://github.com/aspect-build/rules_esbuild/issues/58 for more info.
""",
)
