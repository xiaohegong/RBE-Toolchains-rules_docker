# Bazel

Following tutorial from https://docs.bazel.build/versions/master/tutorial/cpp.html


## Starlark Language
The language used in Bazel (BUILD and .bzl files), syntactically a subset of Python 3.
Some small differences with Python include:
  - global variables $\iff$ `const`
  - `for` and `if` have to be inside of a function
  - no recursion, while, yield
  - class $\rightarrow$ struct, import $\rightarrow$ load
  - string concatenation, lambda, chained comparisons, float and set are not supported


#### Some Useful Commands

###### To build a project
Go to the directory with **WORKSPACE** file (identifies this directory as the root of the project's directory structure)

`bazel build //main:hello-world`
              $\qquad \qquad \qquad\qquad\uparrow$
          $\qquad \qquad$ relative path from root

###### BUILD file
```
cc_library(
    name = "hello-greet",
    srcs = ["hello-greet.cc"],
    hdrs = ["hello-greet.h"],
)

cc_binary(
@recommended -world",
@recommended o-world.cc"],
@recommended
@recommended reet",
@recommended
@recommended
)
```
- If there are $x$ packages in the project, would have $x$ subdirectories each containing a BUILD file.

- The default target are only visible to other targets in the same BUILD file so may need to explicitly set ***visibility***
    ```
    cc_library(
        name = "hello-time",
        srcs = ["hello-time.cc"],
        hdrs = ["hello-time.h"],
        visibility = ["//main:__pkg__"],
    )
    ```

###### Testing
To test the built project, run `bazel-bin/main/hello-world` from root directory

###### Labels
Syntax for *labels*: `//path/to/package:target-name`

- If referencing targets within the same package, can skip the package path
  - Same BUILD file - `:target-name`
  - same path - `//:target-name`
- If the target is a rule target, `path/to/package` is the path to the directory containing the BUILD file
- If the target is a file target then `path/to/package` is the path to the root of the file

## Rules
A rule defines the set of actions that Bazel should perform to get the outputs.

A new rule : `
my_rule = rule(...)
`
Load the rule in BUILD files: `load('//some/pkg:whatever.bzl', 'my_rule')`

#### Attributes
Attributes are rule argument such as `srcs` and `deps`

An example from *cpp-tutorial/stage3/main*
```
my_rule = rule(
  implementation = _my_impl,
  attrs = {
        "srcs": attr.label_list(
            allow_files = True,
        )
    },
)
```
In this example, `srcs` is defined to be an attribute of my_rule. The type of `srcs` is `label_list`, defined in *attr* module.

To use this rule, load and call the rule in the BUILD file
```
load("//main:my_rule.bzl", "my_rule")

my_rule(
  name = "hello-greet",
  srcs = ["hello-greet.cc"],
)
```
To add an private attribute, add an underscore before just as in python.
  - e.g., *"_compiler": ...*


#### Implementation function
This is required for every rule.
This function is executed strictly in the analysis phase and performs series of actions that should be achieved with this rule.
  - It only takes in parameter *rule context* or *ctx*
    - *ctx* can be used to access attribute values, obtain input and output files, create actions and pass information to other target dependencies
    - e.g., `ctx.attr.<attribute_name>` `ctx.file` `ctx.label.name`
  - Convention: private, usually named `_impl`


#### Files
Use `ctx.files` to access input files of a target (`ctx.attr` works too).
Use `ctx.outputs` to access output attributes (can't use `ctx.attr` since it only returns the label).

#### Actions
Execute actions to generate a set of outputs from a set of inputs.
  - `ctx.actions.run`  $\rightarrow$ run an executable
  - `ctx.actions.run_shell`  $\rightarrow$ run a shell command
  - `ctx.actions.write`  $\rightarrow$ write a string to a file
  - `ctx.actions.expand_template`  $\rightarrow$ to generate a file from a template

In addition, there are various situations that should be noted
- **If an action generates a file that is not listed in its outputs**: This is fine, but the file will be ignored and cannot be used by other rules.

- **If an action does not generate a file that is listed in its outputs**: This is an execution error and the build will fail. This happens for instance when a compilation fails.

- **If an action generates an unknown number of outputs and you want to keep them all**, you must group them in a single file (e.g., a zip, tar, or other archive format). This way, you will be able to deterministically declare your outputs.

- **If an action does not list a file it uses as an input**, the action execution will most likely result in an error. The file is not guaranteed to be available to the action, so if it is there, it’s due to coincidence or error.

- **If an action lists a file as an input, but does not use it**: This is fine. However, it can affect action execution order, resulting in sub-optimal performance.

#### Providers
Only way rules exchange data with each other
Communicate using the `provider` function:
`Info = provider(fields=["value"])`

Then define a implementation function and return the provider instances
```
def rule_implementation(ctx):
  ...
  return [Info(value=5)]
```

`Info` is both a provider constructor and a key to access them. A rule can access the providers of its dependencies as accessing key `Info` in a hashmap. The target maps from each provider the target supports to the target's corresponding instance of that provider.

```
def dependent_rule_implementation(ctx):
  ...
  n = 0
  for dep_target in ctx.attr.deps:
    n += dep_target[Info].value
  ...
```
Note how `dep_target[Info]` yields the instance of that provider and we can access its value.

#### Executables rules
Executables rules define targets that can be invoked by a `bazel run` command.

An example from https://github.com/bazelbuild/examples/blob/master/rules/executable/fortune.bzl
```
def _haiku_fortune_impl(ctx):
    ...

    # Emit the executable shell script.
    script = ctx.actions.declare_file("%s-fortune" % ctx.label.name)
    script_content = script_template.format(
        fortunes_file = datafile.short_path,
        num_fortunes = len(ctx.attr.srcs),
    )
    ctx.actions.write(script, script_content, is_executable = True)

    # The datafile must be in the runfiles for the executable to see it.
    runfiles = ctx.runfiles(files = [datafile])
    return [DefaultInfo(executable = script, runfiles = runfiles)]

haiku_fortune = rule(
    implementation = _haiku_fortune_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            doc = "Input haiku files. Each file must have exactly three lines. " +
                  "The last line must be terminated by a newline character.",
        ),
    },
    executable = True,
```

This example demonstrates how an executable is generated. For a `ctx.actions.run()` or `ctx.actions.run_shell()` action this should be done by the underlying tool that is invoked by the action. For a `ctx.actions.write()` action it is done by passing the argument `is_executable=True`.
