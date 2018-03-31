load(
    "@io_bazel_skydoc//skylark:skylark.bzl",
    "skydoc_repositories",
    "skylark_library",
    "skylark_doc",
)

skylark_doc(
    name = "docs",
    srcs = [
        "//java_extensions:jar_repack.bzl",
        "//java_extensions:junit_test.bzl"
    ],
    format = "markdown"
)
