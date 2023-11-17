FROM ubuntu:22.04
MAINTAINER Joakim Bech (joakim.bech@linaro.org)

ENV DEBIAN_FRONTEND noninteractive

ENV TZ=Europe/Stockholm

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update

RUN apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install apt-utils

RUN apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install \
	adb \
	acpica-tools \
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
	fastboot \
	flex \
	ftp-upload \
	gdisk \
	libattr1-dev \
	libcap-dev \
	libcap-ng-dev \
	libfdt-dev \
	libftdi-dev \
	libglib2.0-dev \
	libgmp3-dev \
	libhidapi-dev \
	libmpc-dev \
	libncurses5-dev \
	libpixman-1-dev \
	libssl-dev \
	libtool \
	make \
	mtools \
	netcat \
	ninja-build \
	python3-cryptography \
	python3-pip \
	python3-pyelftools \
	python3-serial \
	python-is-python3 \
	rsync \
	unzip \
	uuid-dev \
	xdg-utils \
	xterm \
	xz-utils \
	zlib1g-dev \
	# extra for Docker only \
	curl \
	cpio \
	git \
	wget

# Download repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

# Exchange 1000 to the user id of the current user
RUN useradd --shell /bin/bash -u 1000 -o -c "" -m optee
RUN echo 'optee:optee' | chpasswd

RUN mkdir -p /home/optee/qemu-optee

ADD launch_optee.sh /home/optee/qemu-optee/launch_optee.sh
RUN chown -R optee:optee /home/optee/qemu-optee

# Set the locale
RUN apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER optee

ENV USE_CCACHE=1
ENV CCACHE_DIR=/home/optee/.ccache
ENV CCACHE_UMASK=002

RUN mkdir -p /home/optee/buildroot_dl
ENV BR2_DL_DIR=/home/optee/buildroot_dl
ENV BR2_CCACHE_DIR=/home/optee/.cache/ccache

# Configure git so repo won't complain later on
RUN git config --global user.name "OP-TEE"
RUN git config --global user.email "op-tee@linaro.org"

ENV TERM=rxvt-256color

WORKDIR /home/optee/qemu-optee

RUN chmod a+x launch_optee.sh
