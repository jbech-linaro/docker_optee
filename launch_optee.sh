#!/bin/bash
echo "This will take some time, since it's cloning lots of code ..."
yes "" | repo init -u https://github.com/OP-TEE/manifest.git
repo sync -j6

echo "Now do this:"
echo " cd build"
echo " make -j2 toolchains && time nice -n 19 make -j`nproc` run"
