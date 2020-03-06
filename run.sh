#!/bin/bash

IMAGE=$1

export GID=$(id -g)

docker run -it \
	-e DISPLAY=$DISPLAY \
	--user optee:$GID \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /media/jbech/TSHB_LINUX/.ccache:/home/optee/.ccache \
	-v /media/jbech/TSHB_LINUX/devel/optee_projects/imx/yocto_downloads:/home/optee/yocto_downloads \
	-v /media/jbech/TSHB_LINUX/devel/optee_projects/imx/yocto_sstate:/home/optee/yocto_sstate \
	-v /media/jbech/TSHB_LINUX/devel/optee_projects/imx/imx-linux-sumo/linux_build:/home/optee/reference \
	$1
