# Bazel

Following tutorial from https://docs.bazel.build/versions/master/tutorial/cpp.html

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
