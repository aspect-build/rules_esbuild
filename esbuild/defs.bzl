"# Public API"

load("@bazel_skylib//lib:types.bzl", "types")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("//esbuild/private:esbuild.bzl", _esbuild = "esbuild_bundle")

def esbuild(name, output_dir = False, splitting = False, config = None, **kwargs):
    """esbuild helper macro around the `esbuild_bundle` rule

    For a full list of attributes, see the [`esbuild_bundle`](./esbuild.md) rule

    Args:
        name: The name used for this rule and output files
        output_dir: If `True`, produce an output directory
        splitting: If `True`, produce a code split bundle in the output directory
        config: an esbuild configuration file
            Can be a dictionary.
            In this case it is converted to json, and a config file is generated
            which exports the resulting object, e.g.
            `export default {...}`
        **kwargs: All other args from `esbuild_bundle`
    """
    srcs = kwargs.pop("srcs", [])
    deps = kwargs.pop("deps", [])
    entry_points = kwargs.get("entry_points", None)

    if output_dir == True or entry_points or splitting == True:
        _esbuild(
            name = name,
            config = config,
            srcs = srcs,
            splitting = splitting,
            output_dir = True,
            deps = deps,
            **kwargs
        )
    else:
        output = "%s.js" % name
        if "output" in kwargs:
            output = kwargs.pop("output")

        # Default sourcemaps to "linked".
        # Leave undefined if set to a False-y value.
        output_map = None
        sourcemap = kwargs.pop("sourcemap", "linked")
        if sourcemap:
            kwargs.update([["sourcemap", sourcemap]])
            if sourcemap != "inline":
                output_map = "%s.map" % output

        _esbuild(
            name = name,
            srcs = srcs,
            config = config,
            output = output,
            output_map = output_map,
            deps = deps,
            **kwargs
        )
