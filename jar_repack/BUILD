package(default_visibility = ["//visibility:public"])

# this binary allows us to re-package java libraries (i.e. what maven shading does). example below:
# bazel build //:jarjar_deploy.jar (need fatjar to include dependencies)
# echo "rule com.sixsense.** com.example.test.@1" > rules
# java -jar bazel-bin/jarjar_deploy.jar process rules source.jar new.jar
java_binary(
    name = "jarjar",
    runtime_deps = [
        "@org_pantsbuild_jarjar//jar",
        "@org_ow2_asm_asm//jar",
        "@org_ow2_asm_asm_commons//jar"
    ],
    main_class = "org.pantsbuild.jarjar.Main"
)
