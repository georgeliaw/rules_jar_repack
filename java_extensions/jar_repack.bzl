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

def jar_repack_repositories():
    """Rules to be invoked from WORKSPACE for remote dependencies."""
    maven_jar(
        name="org_pantsbuild_jarjar",
        artifact="org.pantsbuild:jarjar:1.6.4",
        sha1="bf1e30daf5d8bf737eba553ec8e08aeb4ec02fd2"
    )

    maven_jar(
        name="org_ow2_asm_asm",
        artifact="org.ow2.asm:asm:5.2",
        sha1="4ce3ecdc7115bcbf9d4ff4e6ec638e60760819df"
    )

    maven_jar(
        name="org_ow2_asm_asm_commons",
        artifact="org.ow2.asm:asm-commons:5.2",
        sha1="2f916f2c20f1d04404276cb1c2e6d5d6793dca3f"
    )
