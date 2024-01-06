<!-- Generated with Stardoc: http://skydoc.bazel.build -->

# Public API

<a id="esbuild"></a>

## esbuild

<pre>
esbuild(<a href="#esbuild-name">name</a>, <a href="#esbuild-output_dir">output_dir</a>, <a href="#esbuild-splitting">splitting</a>, <a href="#esbuild-config">config</a>, <a href="#esbuild-kwargs">kwargs</a>)
</pre>

esbuild helper macro around the `esbuild_bundle` rule

For a full list of attributes, see the [`esbuild_bundle`](./esbuild.md) rule


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="esbuild-name"></a>name |  The name used for this rule and output files   |  none |
| <a id="esbuild-output_dir"></a>output_dir |  If `True`, produce an output directory   |  `False` |
| <a id="esbuild-splitting"></a>splitting |  If `True`, produce a code split bundle in the output directory   |  `False` |
| <a id="esbuild-config"></a>config |  an esbuild configuration file Can be a dictionary. In this case it is converted to json, and a config file is generated which exports the resulting object, e.g. `export default {...}`   |  `None` |
| <a id="esbuild-kwargs"></a>kwargs |  All other args from `esbuild_bundle`   |  none |


