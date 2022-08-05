<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

<a id="esbuild"></a>

## esbuild

<pre>
esbuild(<a href="#esbuild-name">name</a>, <a href="#esbuild-output_dir">output_dir</a>, <a href="#esbuild-splitting">splitting</a>, <a href="#esbuild-config">config</a>, <a href="#esbuild-kwargs">kwargs</a>)
</pre>

esbuild helper macro around the `esbuild_bundle` rule

For a full list of attributes, see the `esbuild_bundle` rule


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="esbuild-name"></a>name |  The name used for this rule and output files   |  none |
| <a id="esbuild-output_dir"></a>output_dir |  If <code>True</code>, produce an output directory   |  <code>False</code> |
| <a id="esbuild-splitting"></a>splitting |  If <code>True</code>, produce a code split bundle in the output directory   |  <code>False</code> |
| <a id="esbuild-config"></a>config |  an esbuild configuration file Can be a dictionary. In this case it is converted to json, and a config file is generated which exports the resulting object, e.g. <code>export default {...}</code>   |  <code>None</code> |
| <a id="esbuild-kwargs"></a>kwargs |  All other args from <code>esbuild_bundle</code>   |  none |


