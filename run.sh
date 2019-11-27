#!/bin/bash

IMAGE=$1

export GID=$(id -g)

docker run -it \
	-e DISPLAY=$DISPLAY \
	--user optee:$GID \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /home/jbech/devel/optee_projects/reference:/home/optee/reference \
	-v /home/jbech/.ccache:/home/optee/.ccache \
	$1
