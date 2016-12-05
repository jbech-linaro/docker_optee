FROM ubuntu:latest
MAINTAINER Joakim Bech (joakim.bech@linaro.org)

# This is needed on later Ubuntu distros to be able to install the i386
# packages.
RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install -y --force-yes \
	    android-tools-adb android-tools-fastboot \
	    autoconf bc bison cscope curl flex gdisk git libc6:i386 libfdt-dev \
	    libftdi-dev libglib2.0-dev libhidapi-dev libncurses5-dev \
	    libpixman-1-dev libstdc++6:i386 libtool libz1:i386 make mtools \
	    netcat python python-crypto python-serial python-wand tmux unzip \
	    uuid-dev xdg-utils xterm xz-utils vim zlib1g-dev

# Download repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

# Configure git so repo won't complain later on
RUN git config --global user.name "Joakim Bech"
RUN git config --global user.email "joakim.bech@linaro.com"

RUN mkdir -p /opt/optee-qemu
WORKDIR /opt/optee-qemu

EXPOSE 54320
EXPOSE 54321

RUN /bin/repo init -u https://github.com/OP-TEE/manifest.git
RUN /bin/repo sync -j3

WORKDIR /opt/optee-qemu/build
RUN make toolchains

#RUN make -j4 all run
