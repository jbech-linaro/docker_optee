#!/bin/bash

IMAGE=$1

export GID=$(id -g)

docker run -it \
	-e DISPLAY=$DISPLAY \
	--user optee:$GID \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	$IMAGE
