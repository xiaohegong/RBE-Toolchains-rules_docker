# Rules Docker
Bazel's docker-related rules.

- Do not require or use Docker to pull, push or build images
- Can be used to develop Docker containers without sys requirements (no need for VMs/docker-machine)
- Docker images built by container_image are deterministic and reproducible
  - each builds generate the same SHA256

#### lang_image rules
- distroless
  - a bunch of base images
  - containerize apps not VMs, so need base images as simple as possible
  - can put java code into distroless/java
- Only need to install the machine base
  - No other dependencies
  - Like a syntactic sugar

```
cc_image(
    name = "hello_world_image",
    srcs = ["hello_world.cc"],
)

cc_binary(
    name = "hello_world",
    srcs = ["hello_world.cc"],
)
```


#### OCI Image Serialization
OCI: Open Container Initiative
*Image* is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime
- It is composed of layers, or a set of filesystem changes

## rules_docker_example
https://github.com/erain/rules_docker_example
#### container_image
The following code builds a simple image called helloworld on `ubuntu1604` machine. `entrypoint` mains the first line to executed, say when an application is first launched.

```
container_image(
    name = "helloworld",
    base = "@ubuntu1604//image",
    entrypoint = "echo 'hello world!'",
)
```

#### Image with layers
Consider the following example, `src` is in `layers` of `go_helloworld`.
Run the command `bazel run //examples:go_helloworld`.
  - This block of code builds an docker image with src file (`//lang_images/golang:hello.go`) under directory `/workspace` of the `go_helloworld` image.
  - Now run `docker run -it --rm bazel/examples:go_helloworld`
    - Since the `entrypoint` is set to be `go run /workspace/hello.go`, the file `hello.go` located in `/workspace` will be executed when first launched.
    - You can see "hello world" printed

```
container_image(
    name = "go_helloworld",
    base = "@go_alpine//image",
    entrypoint = "go run /workspace/hello.go",
    layers = [":src"],
)

container_layer(
    name = "src",
    directory = "/workspace",
    files = ["//lang_images/golang:hello.go"],
)
```
The `layers` order is irrelevant if under different dir, will matter if the layers are under the same directory.

#### Pulling and pushing docker images
```
container_push(
    name = "go_helloworld_gcr",
    format = "Docker",
    image = ":go_helloworld",
    registry = "gcr.io",
    repository = "asci-toolchain-sandbox/foo",
    tag = "test",
)

container_pull(
    name = "ubuntu16_04",
    digest = "sha256:c81e8f6bcbab8818fdbe2df6d367990ab55d85b4dab300931a53ba5d082f4296",
    registry = "gcr.io",
    repository = "cloud-marketplace/google/ubuntu16_04",
)
```
`container_pull` is a repository rule, happens in the analysis phase before the execution phase. `container_push` is a regular rule.
- Note that you cannot have pull-push-pull commands completed in a single one
  - need to have all the inputs defined
- If you perform `builds`, `pull`, `push` to the same image, it still gets the same SHA256
- Try `bazel run //examples:go_helloworld_gcr`
