# jar_repack allows us to repackage an existing jar to use a new class name
# Example Usage:
#
# load("//build_tools/java:jar_repack.bzl", "jar_repack")
# jar_repack(
#     name = "jarjar-new",
#     old_class_name = "org.pantsbuild.**",
#     new_class_name = "com.example.test.@1",
#     src_jar = "@org_pantsbuild_jarjar//jar"
# )

def _repack_impl(ctx):
    src_jar_path = "%s/%s" % (
        str(list(ctx.attr.src_jar.files)[0].root).replace('[source]', ''),
        list(ctx.attr.src_jar.files)[0].path
    )

    ctx.action(
        inputs = [
            ctx.executable._jar_repack,
            list(ctx.attr.rulefile.files)[0]
        ],
        outputs = [
            ctx.outputs.jar
        ],
        command = [
            "java",
            "-jar",
            ctx.executable._jar_repack.path,
            "process",
            list(ctx.attr.rulefile.files)[0].path,
            src_jar_path,
            ctx.outputs.jar.path
        ]
    )

_jar_repack_rule = rule(
    implementation = _repack_impl,
    attrs = {
        "_jar_repack": attr.label(
            executable=True,
            cfg="host",
            allow_single_file=True,
            default=Label("//build_tools/java:jarjar_deploy.jar")
        ),
        "rulefile": attr.label(
            mandatory=True,
            allow_single_file=True,
            default=None
        ),
        "old_class_name": attr.string(
            default='',
            mandatory=True
        ),
        "new_class_name": attr.string(
            default='',
            mandatory=True
        ),
        "src_jar": attr.label(
            default=None,
            mandatory=True,
            allow_single_file=True
        )
    },
    outputs = {
        "jar": "%{name}.jar",
    }
)

def jar_repack(name, old_class_name, new_class_name, src_jar):
    native.genrule(
        name = "rulefile",
        outs = [
            "rules"
        ],
        cmd = "echo 'rule %s %s' > $@" % (old_class_name, new_class_name),
    )

    _jar_repack_rule(
        name=name,
        rulefile=":rulefile",
        old_class_name=old_class_name,
        new_class_name=new_class_name,
        src_jar=src_jar
    )
