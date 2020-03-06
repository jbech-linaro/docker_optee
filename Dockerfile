FROM ubuntu:latest
MAINTAINER Joakim Bech (joakim.bech@linaro.org)

ENV DEBIAN_FRONTEND noninteractive

# This is needed on later Ubuntu distros to be able to install the i386
# packages.
RUN dpkg --add-architecture i386

ENV TZ=Europe/Stockholm

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update

RUN apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install apt-utils

RUN apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install \
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
	zlib1g-dev \
	vim \
	sudo \
	# extra for Docker only \
	curl \
	cpio \
	git \
	python \
	wget \
	# extra for IMX-yocto \
	gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev

# Download repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

# Exchange 1000 to the user id of the current user
RUN useradd --shell /bin/bash -u 1000 -o -c "" -m optee
RUN echo 'optee:optee' | chpasswd && adduser optee sudo

# Add and unpack the release
ADD imx-linux-sumo-imx-4.14.98-2.1.0_8mq_drm-wv-2.2.cand20200235_oemcrypto-v15.tgz /home/optee/

# Add the modified script that uses a local repo reference
ADD imx_linux_setup.sh /home/optee/release_linux_tarball/
RUN chown -R optee:optee /home/optee

# Set the locale
RUN apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# NXP are using an old OP-TEE version that needs the old python-crypto
RUN apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install python-crypto

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER optee

RUN export USE_CCACHE=1
RUN export CCACHE_DIR=~/.ccache
RUN export CCACHE_UMASK=002

# Configure git so repo won't complain later on
RUN git config --global user.name "OP-TEE"
RUN git config --global user.email "op-tee@linaro.org"

RUN export TERM=rxvt-256color

# Export Yocto variables pointing to our download and state cache
ENV DL_DIR="/home/optee/yocto_downloads"
ENV SSTATE_DIR="/home/optee/yocto_sstate"

WORKDIR /home/optee
