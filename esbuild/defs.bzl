"Public API re-exports"

load("//esbuild/private:esbuild.bzl", _esbuild = "esbuild_bundle")

def esbuild(name, output_dir = False, splitting = False, **kwargs):
    """esbuild helper macro around the `esbuild_bundle` rule

    For a full list of attributes, see the `esbuild_bundle` rule

    Args:
        name: The name used for this rule and output files
        output_dir: If `True`, produce an output directory
        splitting: If `True`, produce a code split bundle in the output directory
        **kwargs: All other args from `esbuild_bundle`
    """
    srcs = kwargs.pop("srcs", [])
    deps = kwargs.pop("deps", [])
    entry_points = kwargs.get("entry_points", None)

    config = kwargs.pop("config", None)
    if config:
        kwargs.setdefault("config", config)
        deps.append("%s_deps" % config)

    if output_dir == True or entry_points or splitting == True:
        _esbuild(
            name = name,
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

        output_map = None
        sourcemap = kwargs.get("sourcemap", None)
        if sourcemap != "inline":
            output_map = "%s.map" % output

        _esbuild(
            name = name,
            srcs = srcs,
            output = output,
            output_map = output_map,
            deps = deps,
            **kwargs
        )
