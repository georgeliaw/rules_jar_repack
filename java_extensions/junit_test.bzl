# original form taken from https://github.com/bazelbuild/bazel/issues/1017#issuecomment-199326970

# Generates a Junit4 TestSuite
# Assumes srcs are all .java test files
# Assumes junit4 is already added to deps

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
