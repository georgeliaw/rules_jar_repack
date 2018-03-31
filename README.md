# rules_java_extensions
Bazel macros to extend java functionality. Hopefully will be converting them to actual rules in the future.

WORKSPACE:
```
http_archive(
    name = "io_bazel_rules_java_extensions",
    strip_prefix = "rules_java_extensions-<version>",
    urls = ["https://github.com/georgeliaw/rules_java_extensions/archive/<version>.tar.gz"],
    sha256 = "<checksum>"
)
load("@io_bazel_rules_java_extensions//java_extensions:jar_repack.bzl", "jar_repack_repositories")
jar_repack_repositories()
load("@io_bazel_rules_java_extensions//java_extensions:junit_test.bzl", "junit_test_repositories")
junit_test_repositories()
```

## jar_repack
jar_repack allows us to repackage an existing jar to use a new class name (similar to maven shading).

Example Usage:
```
load("@io_bazel_rules_java_extensions//java_extensions:jar_repack.bzl", "jar_repack")
jar_repack(
    name = "jarjar-new",
    old_class_name = "org.pantsbuild.**",
    new_class_name = "com.example.test.@1",
    src_jar = "@org_pantsbuild_jarjar//jar"
)
```

## junit_test
This macro allows JUnit4 tests to be run.

Original form taken from https://github.com/bazelbuild/bazel/issues/1017#issuecomment-199326970

- Generates a Junit4 TestSuite
- Assumes srcs are all .java test files
- Assumes junit4 is already added to deps

Example Usage:
```
load("@io_bazel_rules_java_extensions//java_extensions:junit_test.bzl", "junit_test")
junit_test(
    name = "tests",
    deps = [
        ":libs",
        "@org_apache_lucene_lucene_core//jar",
        "@commons_logging_commons_logging//jar",
        "@org_mockito_mockito_all//jar",
        "@org_powermock_powermock_api_mockito//jar",
        "@org_powermock_powermock_api_support//jar",
        "@org_powermock_powermock_core//jar",
        "@org_powermock_powermock_reflect//jar",
        "@org_javassist_javassist//jar",
        "@org_powermock_powermock_module_junit4//jar",
        "@org_powermock_powermock_module_junit4_common//jar",
        "@org_skyscreamer_jsonassert//jar",
        "@junit_junit//jar",
    ],
    srcs = glob(
        [
            "src/test/**/*.java"
        ]
    )
)
```
