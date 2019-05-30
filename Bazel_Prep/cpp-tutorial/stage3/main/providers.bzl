"""
This is a example on using provider to pass around information between different
rules. To check the result:
1. bazel build //main:msg
2. Check the message from output msg.o, and you will see messages
  from three dependencies cat together.

"""

# Create a msg struct
msg = provider("message")

def _impl(ctx):
    result = ""

    # Iterate through dependents and cat messages
    for dep in ctx.attr.deps:
        result += dep[msg].message
    ctx.actions.write(output = ctx.outputs.out, content = str(result))

    # Return the provider with result, visible to other rules.
    return [msg(message = result)]

def _dep_impl(ctx):
    # As a dependent, returns a struct with field message set to attr.message
    # If you don't set and return this, will get error mandatory provider
    # not provided
    return [msg(message = ctx.attr.message)]

msg_rule2 = rule(
    implementation = _dep_impl,
    attrs = {
        "message": attr.string(default = ""),
    },
)

msg_rule = rule(
  implementation = _impl,
  attrs = {
        # "message": attr.string(default = ""),
        "deps": attr.label_list(providers = [msg]),
    },
  outputs = {"out": "%{name}.o"},
)

