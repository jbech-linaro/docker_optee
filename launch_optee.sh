#!/bin/bash
echo "Using the caches from the host"
yes "" | repo init --partial-clone --reference /home/optee/reference https://github.com/OP-TEE/manifest.git 
repo sync -j12
ln -sf $HOME/toolchains $HOME/qemu-optee/toolchains

echo "Now do this:"
echo " cd build && time nice -n 19 make -j`nproc`" run
