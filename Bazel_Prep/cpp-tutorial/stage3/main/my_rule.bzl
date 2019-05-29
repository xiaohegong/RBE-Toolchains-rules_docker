def _my_impl(ctx):
  out = ctx.actions.declare_file("%s.o" % ctx.attr.name)
  compiler(ctx, ctx.files.srcs, out)


def compiler(ctx, srcs, out):
  cmd = "g++ -o {} -c {srcs}".format(
      ctx.attr.name,
      srcs = " ".join([_quote(src.path) for src in srcs])
  )

  ctx.actions.run_shell(
        outputs = [out],
        inputs = srcs,
        command = cmd,
        use_default_shell_env = True,
    )


# From: https://github.com/bazelbuild/bazel-skylib/blob/master/lib/shell.bzl
def _quote(s):
    """Quotes the given string for use in a shell command.
    This function quotes the given string (in case it contains spaces or other
    shell metacharacters.)
    Args:
      s: The string to quote.
    Returns:
      A quoted version of the string that can be passed to a shell command.
    """
    return "'" + s.replace("'", "'\\''") + "'"

my_rule = rule(
  implementation = _my_impl,
  attrs = {
        "srcs": attr.label_list(
            allow_files = True,
        )
    },
)
