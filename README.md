# rules_java_extensions
Bazel rules to extend java functionality.

## jar_repack
jar_repack allows us to repackage an existing jar to use a new class name (similar to maven shading).

Example Usage:
```
load("//build_tools/java:jar_repack.bzl", "jar_repack")
jar_repack(
    name = "jarjar-new",
    old_class_name = "org.pantsbuild.**",
    new_class_name = "com.example.test.@1",
    src_jar = "@org_pantsbuild_jarjar//jar"
)
```

## junit_test
This rule is to allow JUnit4 tests to be run.

Original form taken from https://github.com/bazelbuild/bazel/issues/1017#issuecomment-199326970

- Generates a Junit4 TestSuite
- Assumes srcs are all .java test files
- Assumes junit4 is already added to deps
