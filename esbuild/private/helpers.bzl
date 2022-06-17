"""
Utility helper functions for the esbuild rule
"""

TS_EXTENSIONS = ["ts", "tsx"]
JS_EXTENSIONS = ["js", "jsx", "mjs"]
ALLOWED_EXTENSIONS = JS_EXTENSIONS + TS_EXTENSIONS

def desugar_entry_point_names(entry_point, entry_points):
    """Users can specify entry_point (sugar) or entry_points (long form).

    This function allows our code to treat it like they always used the long form.

    It also validates that exactly one of these attributes should be specified.

    Args:
        entry_point: the simple argument for specifying a single entry
        entry_points: the long form argument for specifing one or more entry points

    Returns:
        the array of entry poitns
    """
    if entry_point and entry_points:
        fail("Cannot specify both entry_point and entry_points")
    if not entry_point and not entry_points:
        fail("One of entry_point or entry_points must be specified")
    if entry_point:
        return [entry_point]
    return entry_points

def filter_files(input, endings = ALLOWED_EXTENSIONS):
    """Filters a list of files for specific endings

    Args:
        input: The depset or list of files
        endings: The list of endings that should be filtered for

    Returns:
        Returns the filtered list of files
    """

    # Convert input into list regardles of being a depset or list
    input_list = input.to_list() if type(input) == "depset" else input
    filtered = []

    for file in input_list:
        for ending in endings:
            if file.path.endswith("." + ending):
                filtered.append(file)
                continue

    return filtered

def write_args_file(ctx, args):
    args_file = ctx.actions.declare_file("%s.args.json" % ctx.attr.name)
    ctx.actions.write(
        output = args_file,
        content = json.encode(args),
    )

    return args_file
