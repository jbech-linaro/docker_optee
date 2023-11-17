Dockerfile for OP-TEE
=====================

With this Dockerfile, you can quickly and easy test OP-TEE on your local
desktop. The steps to create the Docker image is as follows:

```bash
$ git clone <this_repository>
$ cd <this_repository>
$ docker build -t optee-cached .
```
It will take ~30 minutes or so to download everything, this is highly dependant
on the speed to your ISP. Note that when repo are synching, it looks like
nothing happens, but indeed it does, so just relax and let it work until done.

When all is done, you'll have a Docker image based on Ubuntu containing OP-TEE
with all source code and toolchains necessary to build and test it out. Since
the test spawns new `xterm` windows, we need to provide some extra parameters
when running the Docker container. To run it, simply type:
```bash
$ ./run.sh optee-cached
```

When in the Docker environment follow the instructions and run:
```bash
$ ./launch_optee.sh
```

In case it still doesn't work, you can grant X11 access to anyone by running `$
xhost +`, however, be **really** careful when doing so since, you basically open
up to open any X11 window on you machine.

If you detach from that container and later on need to attach to it again, you
will need to type:

```bash
# First find the name of the container, "silly_bhaskara" in my case.
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED STATUS                      PORTS               NAMES
552fbaee5d73        optee-cached        "/bin/bash"         4 hours ago                                             silly_bhaskara

# If not already running, you need to start the container.
$ docker start silly_bhaskara

# Finally re-attach to the running container
$ docker attach silly_bhaskara
```
