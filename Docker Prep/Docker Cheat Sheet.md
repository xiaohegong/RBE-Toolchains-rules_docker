# Docker

## Set up and first docker image
Install docker at: http://go/installdocker

#####Test if installed successfully
```
sudo docker run hello-world
```
To use *sudoless Docker* run `sudo adduser $USER$ docker`

What happened in the `hello-world` program:
1. Look for an image named *hello-world*
   - No image stored / created yet so cannot find *hello-world*
2. Go to default registry *Docker Store* and look for an image named hello-world
3. Pull the image and runs it in the container
   - Outputs welcome message

## Docker Images and Containers
Docker Images are static, while docker container is created at run time.
  - First, pull a docker image called *alpine*
      `docker image pull alpine`
      - Can check all images in system
        `docker image ls`
  - Run a **Docker container based on this image**
      `docker container run alpine ls -l`
      - What happened:
          - Execute `docker container run alpine` -> creates the container
          - Runs command `ls -l`
          - Container shuts down after `ls` finished
          - Send output of `ls -l` back to host OS
  - **Note**:
    - Each container will shut down after the command finished executing
    - Each container is isolated
      - If you create hello.txt in container *alpine*, after you `exit` and rerun the container you will notice "hello.txt" is missing:
        `docker container run -it alpine /bin/ash`
        Input:
        ```
         echo "hello world" > hello.txt

         ls
        ```
        Then `exit` and re-run `docker container run alpine ls`

   - If the container is not exited can start the container again using its id
      - Use  `docker container ls` to get list of containers

          ```
              CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
              3030c9c91e12        alpine              "/bin/ash"                2 minutes ago       Up 14 seconds                        distracted_bhaskara
          ```
      - Run `docker container start 3030c9c91e12` or  `docker container start 3030` (first few digits that uniquely identifies the container)
      - Execute command `ls` with: `docker container exec 3030 ls`
      - "hello.txt" will be there :)

To summarize
- ***Images***: file system and configuration of an application which are used to create containers, e.g., *hello-world*, *alpine*
- ***Containers***: Running instances of Docker images, runs the actual applications with all of its dependencies. Runs as an isolated process on the host OS from the other processes.

## Image creation
How to create our own images
####Image creation from a container
This will create a image that "records" every package and configuration process that was installed to the application.
With this image created, we can easily share these configurations in order for the team to get the exact configured application.

- Start with an interactive shell in a ubuntu container: `docker container run -ti ubuntu bash`

- Install some customized packages: e.g., figlet
    ```
    apt-get update
    apt-get install -y figlet
    figlet "hello docker"
    ```
- Create an image by making a commit to the container
    - Get the container ID: `docker container ls -a`
    - `docker container commit CONTAINER_ID`
    This creates an new image, verify using `docker image ls`. We can also rename the image with a tag for future uses: `docker image tag <IMAGE_ID> ourfiglet`


#### Image creation using a Dockerfile
Alternatively, we can create a image by describing the set of instructions in a Dockerfile, a similar concept with Makefile and package.json. This method is more adaptable for changes than building the image as we don't need to modify the raw binaary files.

- Create instruction *Dockerfile* and application code *index.js*
- Build the image with `docker image build -t hello:v0.1 .`
  - *hello:v0.1* is the image created using the instructions in the *Dockerfile*
  - i.e., **FROM** alpine **RUN** apk commands **COPY** and SET **WORKDIR** to /app in the container then run **CMD** node index.js
- Run the application: `docker container run hello:v0.1`

**Note:**
- Images built with Docker are built in **layers**, as shown below with 5 different steps

    ```
    Sending build context to Docker daemon  7.168kB
    Step 1/5 : FROM alpine
    ---> 055936d39205
    Step 2/5 : RUN apk update && apk add nodejs
    ---> Running in 913a276c05d6
    fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/main/x86_64/APKINDEX.tar.gz
    fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/community/x86_64/APKINDEX.tar.gz
    v3.9.4-6-gce4b56ee80 [http://dl-cdn.alpinelinux.org/alpine/v3.9/main]
    v3.9.4-5-gcfdf5452f1 [http://dl-cdn.alpinelinux.org/alpine/v3.9/community]
    OK: 9770 distinct packages available
    (1/7) Installing ca-certificates (20190108-r0)
    (2/7) Installing c-ares (1.15.0-r0)
    (3/7) Installing libgcc (8.3.0-r0)
    (4/7) Installing http-parser (2.8.1-r0)
    (5/7) Installing libstdc++ (8.3.0-r0)
    (6/7) Installing libuv (1.23.2-r0)
    (7/7) Installing nodejs (10.14.2-r0)
    Executing busybox-1.29.3-r10.trigger
    Executing ca-certificates-20190108-r0.trigger
    OK: 31 MiB in 21 packages
    Removing intermediate container 913a276c05d6
    ---> 332015deb735
    Step 3/5 : COPY . /app
    ---> cb5fea54c3ee
    Step 4/5 : WORKDIR /app
    ---> Running in 024f3ecdb03e
    Removing intermediate container 024f3ecdb03e
    ---> 67ced302784a
    Step 5/5 : CMD ["node","index.js"]
    ---> Running in b689b36856c2
    Removing intermediate container b689b36856c2
    ---> bd33994870b5
    Successfully built bd33994870b5
    Successfully tagged hello:v0.1
    ```
- When rebuilding this image after making a minor change, many of the previously built layers could use a cached version and avoiding inefficient works
    ```
    Sending build context to Docker daemon  86.15MB
    Step 1/5 : FROM alpine
    ---> 7328f6f8b418
    Step 2/5 : RUN apk update && apk add nodejs
    ---> Using cache
    ---> 2707762fca63
    .....
    ```

## Image Inspection
Run `docker image inspect alpine` for information on image *alpine*:
  - layers
  - driver
  - architecture and metadata
  - .....
  -
To inspect the list of layers run `docker image inspect --format "{{ json .RootFS.Layers }}" alpine`
