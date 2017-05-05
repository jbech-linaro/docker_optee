#!/bin/bash

docker run -ti \
	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /home/jbech/devel/optee_projects/reference:/home/optee/reference \
	-v /home/jbech/.ccache:/home/optee/.ccache \
	optee_mnt
