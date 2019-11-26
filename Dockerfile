FROM ubuntu:latest
MAINTAINER Joakim Bech (joakim.bech@linaro.org)

# This is needed on later Ubuntu distros to be able to install the i386
# packages.
RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install -y --force-yes \
	android-tools-adb \
	android-tools-fastboot \
	autoconf \
	automake \
	bc \
	bison \
	build-essential \
	ccache \
	cscope \
	curl \
	device-tree-compiler \
	expect \
	flex \
	ftp-upload \
	gdisk \
	iasl \
	libattr1-dev \
	libc6:i386 \
	libcap-dev \
	libfdt-dev \
	libftdi-dev \
	libglib2.0-dev \
	libhidapi-dev \
	libncurses5-dev \
	libpixman-1-dev \
	libssl-dev \
	libstdc++6:i386 \
	libtool \
	libz1:i386 \
	make \
	mtools \
	netcat \
	python3-crypto \
	python3-pycryptodome \
	python3-pyelftools \
	python3-serial \
	rsync \
	unzip \
	uuid-dev \
	xdg-utils \
	xterm \
	xz-utils \
	zlib1g-dev

# Download repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

# Exchange 1001 to the user id of the current user
RUN useradd --shell /bin/bash -u 1001 -o -c "" -m optee
RUN echo 'optee:optee' | chpasswd

RUN mkdir -p /home/optee/qemu-optee

ADD launch_optee.sh /home/optee/qemu-optee/launch_optee.sh
RUN chown -R optee:optee /home/optee/qemu-optee

USER optee

RUN export USE_CCACHE=1
RUN export CCACHE_DIR=~/.ccache
RUN export CCACHE_UMASK=002

# Configure git so repo won't complain later on
RUN git config --global user.name "OP-TEE"
RUN git config --global user.email "op-tee@linaro.org"

WORKDIR /home/optee/qemu-optee

RUN chmod a+x launch_optee.sh

WORKDIR /home/optee/qemu-optee
