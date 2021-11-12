#!/bin/bash

docker run -ti \
	-e DISPLAY=$DISPLAY \
	--build-arg ARG_TIMEZONE=$(cat /etc/timezone) \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	optee
