load("//main:providers.bzl", "msg_rule", "msg_rule2")

msg_rule2(
  name = "dep1",
  message = "Hi, I am msg 1\n",
)

msg_rule2(
  name = "dep2",
  message = "Hi, I am msg 2\n",
)

msg_rule2(
  name = "dep3",
  message = "Hi, I am msg 3\n",
)

msg_rule(
    name = "msg",
    deps = [
        ":dep1",
        ":dep2",
        ":dep3",
    ],
)
