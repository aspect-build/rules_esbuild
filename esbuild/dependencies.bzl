"""Starlark helper to fetch rules_esbuild dependencies.

Deprecated: Use bzlmod (MODULE.bazel) instead. rules_esbuild now requires
aspect_rules_js v3+ which only supports bzlmod.
"""

def rules_esbuild_dependencies():
    fail("""rules_esbuild_dependencies() is no longer supported.

rules_esbuild now requires aspect_rules_js v3.0+ which only supports bzlmod.
Please migrate to MODULE.bazel. See https://bazel.build/external/migration for guidance.
""")
