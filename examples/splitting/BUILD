load("@aspect_rules_esbuild//esbuild:defs.bzl", "esbuild")
load("//examples:asserts.bzl", "assert_contains")

esbuild(
    name = "bundle",
    entry_point = "index.ts",
    splitting = True,
)

# Asserting that the macro has the expected output.
assert_contains(
    name = "test",
    actual = ":bundle",
    expected = """// examples/splitting/index.ts
console.log("Hello world");
//# sourceMappingURL=index.js.map""",
    path = "examples/splitting/bundle/index.js",
)