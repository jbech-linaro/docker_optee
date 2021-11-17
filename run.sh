#!/bin/bash

IMAGE=$1

export GID=$(id -g)

docker run -it \
	-e DISPLAY=$DISPLAY \
	--user optee:$GID \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /home/jyx/devel/optee_projects/reference:/home/optee/reference \
	-v /opt/.ccache:/home/optee/.ccache \
	-v /opt/buildroot_dl:/home/optee/buildroot_dl \
	-v /home/jyx/toolchains:/home/optee/toolchains \
	$IMAGE
