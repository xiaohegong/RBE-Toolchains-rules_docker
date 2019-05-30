load("//main:my_rule.bzl", "my_rule")

my_rule(
  name = "hello-greet",
  srcs = ["hello-greet.cc"],
)


cc_binary(
    name = "hello-world",
    srcs = ["hello-world.cc"],
    deps = [
        ":hello-greet",
        "//lib:hello-time",
    ],
)
