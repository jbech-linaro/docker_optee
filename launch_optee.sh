#!/bin/bash
repo init -u https://github.com/OP-TEE/manifest.git --reference /home/optee/reference
repo sync -j3
ln -sf $HOME/toolchains $HOME/qemu-optee/toolchains
