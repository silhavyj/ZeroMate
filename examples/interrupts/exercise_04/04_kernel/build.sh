#!/bin/bash

mkdir -p build >/dev/null 2>&1
cd build

cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="../00_cmake/toolchain-arm-none-eabi-rpi0.cmake" ..

make
#make VERBOSE=1
