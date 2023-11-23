Dockerfile for OP-TEE
=====================

With this Dockerfile, you can quickly and easy test OP-TEE on your local
desktop. The steps to create the Docker image is as follows:

```bash
$ git clone <this_repository>
$ cd <this_repository>
$ docker build -t optee .
```
It will take ~30 minutes or so to download everything, this is highly dependant
on the speed to your ISP. Note that when repo are synching, it looks like
nothing happens, but indeed it does, so just relax and let it work until done.

When all is done, you'll have a Docker image based on Ubuntu containing OP-TEE
with all source code and toolchains necessary to build and test it out. Since
the test spawns new `xterm` windows, we need to provide some extra parameters
when running the Docker container. To run it, simply type:

```bash
$ docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix optee
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
552fbaee5d73        optee               "/bin/bash"         4 hours ago                                             silly_bhaskara

# If not already running, you need to start the container.
$ docker start silly_bhaskara

# Finally re-attach to the running container
$ docker attach silly_bhaskara
```

### Additional Xterm Help
Once you run the docker run command above and are at the '/home/optee/qemu-optee' 
command line, you run the `./launch_optee.sh` script and you get an error about 
not being able to find the xterm (xQuartz) server that looks like this
```bash
* QEMU is now waiting to start the execution
* Start execution with either a 'c' followed by <enter> in the QEMU console or
* attach a debugger and continue from there.
*
* To run OP-TEE tests, use the xtest command in the 'Normal World' terminal
* Enter 'xtest -h' for help.

xterm: Xt error: Can't open display: /private/tmp/com.apple.launchd.CuNDWxl9fm/org.xquartz:0
xterm: Xt error: Can't open display: /private/tmp/com.apple.launchd.CuNDWxl9fm/org.xquartz:0
``` 
you don't need to restart the container to fix it. First, press CNTRL-c. 

Try `export DISPLAY=host.docker.internal:0` at the command line and follow that 
with `make run`. The use of `export DISPLAY=host.docker.internal:0` came from 
this conversation 
https://gist.github.com/cschiewek/246a244ba23da8b9f0e7b11a68bf3285?permalink_comment_id=3477013#gistcomment-3477013

### Troubleshooting Docker Build
If you have built the image more than once and start to get strange errors that a 
package can't be found (acts like you haven't run `apt-get update`) try pruning 
the builder cache like this.
```bash
$ docker builder prune
```
Then try building again. The issue is that the previous `apt-get update` has 
gotten cached and the `docker builder prune` clears that cache.

### Getting Root at the Docker Run Commandline
After you execute the docker run command (as above) you will be put into a command 
line where the toolchain and the QEMU environment will be built and run.  
At the `/qemu-optee$ ` prompt if you run the `whoami` you will be `optee`.  
If you need to be root (IDK: to add a package) the way to get that access is to 
access the container again using `docker exec -it -u 0 <container_name> /bin/bash` where 
you would replace `<container_name>` with the container name you would find by 
doing the `docker ps` command. This should give you root access.