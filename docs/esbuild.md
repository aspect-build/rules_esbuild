<!-- Generated with Stardoc: http://skydoc.bazel.build -->

# esbuild rule

<a id="esbuild_bundle"></a>

## esbuild_bundle

<pre>
esbuild_bundle(<a href="#esbuild_bundle-name">name</a>, <a href="#esbuild_bundle-args_file">args_file</a>, <a href="#esbuild_bundle-bazel_sandbox_plugin">bazel_sandbox_plugin</a>, <a href="#esbuild_bundle-bundle">bundle</a>, <a href="#esbuild_bundle-config">config</a>, <a href="#esbuild_bundle-data">data</a>, <a href="#esbuild_bundle-define">define</a>, <a href="#esbuild_bundle-deps">deps</a>,
               <a href="#esbuild_bundle-entry_point">entry_point</a>, <a href="#esbuild_bundle-entry_points">entry_points</a>, <a href="#esbuild_bundle-esbuild_log_level">esbuild_log_level</a>, <a href="#esbuild_bundle-external">external</a>, <a href="#esbuild_bundle-format">format</a>, <a href="#esbuild_bundle-js_log_level">js_log_level</a>, <a href="#esbuild_bundle-launcher">launcher</a>,
               <a href="#esbuild_bundle-max_threads">max_threads</a>, <a href="#esbuild_bundle-metafile">metafile</a>, <a href="#esbuild_bundle-minify">minify</a>, <a href="#esbuild_bundle-output">output</a>, <a href="#esbuild_bundle-output_css">output_css</a>, <a href="#esbuild_bundle-output_dir">output_dir</a>, <a href="#esbuild_bundle-output_map">output_map</a>, <a href="#esbuild_bundle-platform">platform</a>,
               <a href="#esbuild_bundle-sourcemap">sourcemap</a>, <a href="#esbuild_bundle-sources_content">sources_content</a>, <a href="#esbuild_bundle-splitting">splitting</a>, <a href="#esbuild_bundle-srcs">srcs</a>, <a href="#esbuild_bundle-target">target</a>, <a href="#esbuild_bundle-tsconfig">tsconfig</a>)
</pre>

Runs the esbuild bundler under Bazel

For further information about esbuild, see https://esbuild.github.io/

Note: esbuild currently follows symlinks and leaves the bazel sandbox, see https://github.com/aspect-build/rules_esbuild/issues/58 for potential issues and workarounds.

For example, escaping the sandbox may require extra configuration such as overriding the default `resolveExtensions` to not load .ts[x] files that are pre-compiled by other rules.


**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="esbuild_bundle-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="esbuild_bundle-args_file"></a>args_file |  Internal use only   | <a href="https://bazel.build/concepts/labels">Label</a> | optional | <code>None</code> |
| <a id="esbuild_bundle-bazel_sandbox_plugin"></a>bazel_sandbox_plugin |  If true, a custom bazel-sandbox plugin will be enabled that prevents esbuild from leaving the Bazel sandbox.         See https://github.com/aspect-build/rules_esbuild/pull/160 for more info.   | Boolean | optional | <code>True</code> |
| <a id="esbuild_bundle-bundle"></a>bundle |  If true, esbuild will bundle the input files, inlining their dependencies recursively   | Boolean | optional | <code>True</code> |
| <a id="esbuild_bundle-config"></a>config |  Configuration file used for esbuild. Note that options set in this file may get overwritten. If you formerly used <code>args</code> from rules_nodejs' npm package <code>@bazel/esbuild</code>, replace it with this attribute.         TODO: show how to write a config file that depends on plugins, similar to the esbuild_config macro in rules_nodejs.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional | <code>None</code> |
| <a id="esbuild_bundle-data"></a>data |  Runtime dependencies to include in binaries/tests that depend on this target.<br><br>The transitive npm dependencies, transitive sources, default outputs and runfiles of targets in the <code>data</code> attribute are added to the runfiles of this target. They should appear in the '*.runfiles' area of any executable which has a runtime dependency on this target.<br><br>If this list contains linked npm packages, npm package store targets or other targets that provide <code>JsInfo</code>, <code>NpmPackageStoreInfo</code> providers are gathered from <code>JsInfo</code>. This is done directly from the <code>npm_package_store_deps</code> field of these. For linked npm package targets, the underlying <code>npm_package_store</code> target(s) that back the links is used. Gathered <code>NpmPackageStoreInfo</code> providers are propagated to the direct dependencies of downstream linked <code>npm_package</code> targets.<br><br>NB: Linked npm package targets that are "dev" dependencies do not forward their underlying <code>npm_package_store</code> target(s) through <code>npm_package_store_deps</code> and will therefore not be propagated to the direct dependencies of downstream linked <code>npm_package</code> targets. npm packages that come in from <code>npm_translate_lock</code> are considered "dev" dependencies if they are have <code>dev: true</code> set in the pnpm lock file. This should be all packages that are only listed as "devDependencies" in all <code>package.json</code> files within the pnpm workspace. This behavior is intentional to mimic how <code>devDependencies</code> work in published npm packages.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional | <code>[]</code> |
| <a id="esbuild_bundle-define"></a>define |  A dict of global identifier replacements. Values are subject to $(location ...) expansion. Example: <pre><code>python esbuild( name = "bundle", define = { "process.env.NODE_ENV": "production" }, ) </code></pre><br><br>See https://esbuild.github.io/api/#define for more details   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional | <code>{}</code> |
| <a id="esbuild_bundle-deps"></a>deps |  A list of direct dependencies that are required to build the bundle   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional | <code>[]</code> |
| <a id="esbuild_bundle-entry_point"></a>entry_point |  The bundle's entry point (e.g. your main.js or app.js or index.js)<br><br>This is a shortcut for the <code>entry_points</code> attribute with a single entry. Specify either this attribute or <code>entry_point</code>, but not both.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional | <code>None</code> |
| <a id="esbuild_bundle-entry_points"></a>entry_points |  The bundle's entry points (e.g. your main.js or app.js or index.js)<br><br>Specify either this attribute or <code>entry_point</code>, but not both.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional | <code>[]</code> |
| <a id="esbuild_bundle-esbuild_log_level"></a>esbuild_log_level |  Set the logging level of esbuild.<br><br>        We set a default of "warmning" since the esbuild default of "info" includes         an output file summary which is slightly redundant under Bazel and may lead         to spammy <code>bazel build</code> output.<br><br>        See https://esbuild.github.io/api/#log-level for more details.   | String | optional | <code>"warning"</code> |
| <a id="esbuild_bundle-external"></a>external |  A list of module names that are treated as external and not included in the resulting bundle<br><br>See https://esbuild.github.io/api/#external for more details   | List of strings | optional | <code>[]</code> |
| <a id="esbuild_bundle-format"></a>format |  The output format of the bundle, defaults to iife when platform is browser and cjs when platform is node. If performing code splitting or multiple entry_points are specified, defaults to esm.<br><br>See https://esbuild.github.io/api/#format for more details   | String | optional | <code>""</code> |
| <a id="esbuild_bundle-js_log_level"></a>js_log_level |  Set the logging level for js_binary launcher and the JavaScript bazel-sandbox plugin.<br><br>        Log levels: fatal, error, warn, info, debug   | String | optional | <code>"error"</code> |
| <a id="esbuild_bundle-launcher"></a>launcher |  Override the default esbuild wrapper, which is supplied by the esbuild toolchain   | <a href="https://bazel.build/concepts/labels">Label</a> | optional | <code>None</code> |
| <a id="esbuild_bundle-max_threads"></a>max_threads |  Sets the <code>GOMAXPROCS</code> variable to limit the number of threads that esbuild can run with. This can be useful if running many esbuild rule invocations in parallel, which has the potential to cause slowdown. For general use, leave this attribute unset.   | Integer | optional | <code>0</code> |
| <a id="esbuild_bundle-metafile"></a>metafile |  If true, esbuild creates a metafile along with the output   | Boolean | optional | <code>False</code> |
| <a id="esbuild_bundle-minify"></a>minify |  Minifies the bundle with the built in minification. Removes whitespace, shortens identifieres and uses equivalent but shorter syntax.<br><br>Sets all --minify-* flags<br><br>See https://esbuild.github.io/api/#minify for more details   | Boolean | optional | <code>False</code> |
| <a id="esbuild_bundle-output"></a>output |  Name of the output file when bundling   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  |
| <a id="esbuild_bundle-output_css"></a>output_css |  Declare a .css file will be output next to output bundle.<br><br>If your JS code contains import statements that import .css files, esbuild will place the content in a file next to the main output file, which you'll need to declare. If your output file is named 'foo.js', you should set this to 'foo.css'.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  |
| <a id="esbuild_bundle-output_dir"></a>output_dir |  If true, esbuild produces an output directory containing all output files   | Boolean | optional | <code>False</code> |
| <a id="esbuild_bundle-output_map"></a>output_map |  Name of the output source map when bundling   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  |
| <a id="esbuild_bundle-platform"></a>platform |  The platform to bundle for.<br><br>See https://esbuild.github.io/api/#platform for more details   | String | optional | <code>"browser"</code> |
| <a id="esbuild_bundle-sourcemap"></a>sourcemap |  Defines where sourcemaps are output and how they are included in the bundle. If <code>linked</code>, a separate <code>.js.map</code> file is generated and referenced by the bundle. If <code>external</code>, a separate <code>.js.map</code> file is generated but not referenced by the bundle. If <code>inline</code>, a sourcemap is generated and its contents are inlined into the bundle (and no external sourcemap file is created). If <code>both</code>, a sourcemap is inlined and a <code>.js.map</code> file is created.<br><br>See https://esbuild.github.io/api/#sourcemap for more details   | String | optional | <code>""</code> |
| <a id="esbuild_bundle-sources_content"></a>sources_content |  If False, omits the <code>sourcesContent</code> field from generated source maps<br><br>See https://esbuild.github.io/api/#sources-content for more details   | Boolean | optional | <code>False</code> |
| <a id="esbuild_bundle-splitting"></a>splitting |  If true, esbuild produces an output directory containing all the output files from code splitting for multiple entry points<br><br>See https://esbuild.github.io/api/#splitting and https://esbuild.github.io/api/#entry-points for more details   | Boolean | optional | <code>False</code> |
| <a id="esbuild_bundle-srcs"></a>srcs |  Source files to be made available to esbuild   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional | <code>[]</code> |
| <a id="esbuild_bundle-target"></a>target |  Environment target (e.g. es2017, chrome58, firefox57, safari11,  edge16, node10, esnext). Default es2015.<br><br>See https://esbuild.github.io/api/#target for more details   | String | optional | <code>"es2015"</code> |
| <a id="esbuild_bundle-tsconfig"></a>tsconfig |  TypeScript configuration file used by esbuild. Default to an empty file with no configuration.<br><br>        See https://esbuild.github.io/api/#tsconfig for more details   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="lib.implementation"></a>

## lib.implementation

<pre>
lib.implementation(<a href="#lib.implementation-ctx">ctx</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="lib.implementation-ctx"></a>ctx |  <p align="center"> - </p>   |  none |


