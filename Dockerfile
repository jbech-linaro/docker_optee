FROM ubuntu:latest
MAINTAINER Joakim Bech (joakim.bech@linaro.org)

# This is needed on later Ubuntu distros to be able to install the i386
# packages.
RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install -y --force-yes \
	    android-tools-adb \
	    android-tools-fastboot \
	    autoconf \
	    bc \
	    bison \
	    cscope \
	    curl \
	    flex \
	    gdisk \
	    git \
	    libc6:i386 \
	    libfdt-dev \
	    libftdi-dev \
	    libglib2.0-dev \
	    libhidapi-dev \
	    libncurses5-dev \
	    libpixman-1-dev \
	    libstdc++6:i386 \
	    libtool \
	    libz1:i386 \
	    make \
	    mtools \
	    netcat \
	    python \
	    python-crypto \
	    python-serial \
	    python-wand \
	    tmux \
	    unzip \
	    uuid-dev \
	    xdg-utils \
	    xterm \
	    xz-utils \
	    vim \
	    zlib1g-dev

# Download repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

RUN useradd --create-home --shell /bin/bash optee
RUN echo 'optee:optee' | chpasswd

USER optee

# Configure git so repo won't complain later on
RUN git config --global user.name "OP-TEE"
RUN git config --global user.email "op-tee@linaro.org"

RUN mkdir -p /home/optee/qemu-optee
WORKDIR /home/optee/qemu-optee

RUN /bin/repo init -u https://github.com/OP-TEE/manifest.git
RUN /bin/repo sync -j3

WORKDIR /home/optee/qemu-optee/build
RUN make toolchains

#RUN make -j4 all run
