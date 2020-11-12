#!/bin/bash

IMAGE=$1

export GID=$(id -g)

docker run -it \
	-e DISPLAY=$DISPLAY \
	--user optee:$GID \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /media/jbech/TSHB_LINUX/devel/optee_projects/reference:/home/optee/reference \
	-v /media/jbech/TSHB_LINUX/.ccache:/home/optee/.ccache \
	-v /home/jbech/tmp/buildroot_dl:/home/optee/buildroot_dl \
	$IMAGE
