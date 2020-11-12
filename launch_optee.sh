#!/bin/bash
echo "This will take some time, since it's cloning lots of code ..."
repo init -u https://github.com/OP-TEE/manifest.git
repo sync -j3

echo "Now do this:"
echo "$ cd build"
echo "$ make -j2 toolchains"
echo "$ make -j8 run"
