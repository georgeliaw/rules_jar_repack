_TEMPLATE = """import org.junit.runners.Suite;
import org.junit.runner.RunWith;

@RunWith(Suite.class)
@Suite.SuiteClasses({%s})
public class %s {}
"""

_PREFIXES = ("org", "com", "io")

def _prefix_index(tokens):
    for prefix in _PREFIXES:
        if prefix in tokens:
            return tokens.index(prefix)
    fail("%s does not contain any of %s" % (tokens, _PREFIXES))

def _class_name(fname):
    fname = [file.path for file in fname.files][0]
    tokens = fname.replace(".java", "").split("/")
    return ".".join(tokens[_prefix_index(tokens):]) + ".class"

# TODO switch from file_action to template_action
def _impl(ctx):
    classes = ",".join([_class_name(source) for source in ctx.attr.srcs])
    ctx.file_action(
        output=ctx.outputs.out,
        content=_TEMPLATE % (classes, ctx.attr.outname)
    )

_gen_test_suite = rule(
    implementation=_impl,
    attrs={
        "srcs": attr.label_list(allow_files=True),
        "outname": attr.string(),
    },
    outputs={
        "out": "%{name}.java"
    }
)


def junit_test(name, srcs, **kwargs):
    suite_name = name + "TestSuite"
    _gen_test_suite(name=suite_name,
                    srcs=srcs,
                    outname=suite_name)
    native.java_test(name=name,
                     test_class=suite_name,
                     srcs = srcs + [":"+suite_name],
                     **kwargs)

def junit_test_repositories():
    """Rules to be invoked from WORKSPACE for remote dependencies."""
    native.maven_jar(
        name="junit_junit",
        artifact="junit:junit:4.11",
        sha1="4e031bb61df09069aeb2bffb4019e7a5034a4ee0"
    )
