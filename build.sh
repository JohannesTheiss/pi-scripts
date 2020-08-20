#!/bin/bash

### call this script from your build dir ### 

### CHANGE THESE SETTINGS IF NEEDED ###
WORKINGDIR=/home/johannes/fh/GPS_Logbook/Pi/raspi-qt
SOURCEDIR=$WORKINGDIR/qt-src

PIUSER="pi"
PINAME="logbook"

# 1. C++17
toolchain1=$WORKINGDIR/tools/gcc-toolchain/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

# 2. work C++11 
#toolchain2=$WORKINGDIR/tools/rasp-toolchain/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-

##### BUILD QT ######
echo -e "\e[1;32mbuild qt....\e[0m" 
$SOURCEDIR/qtbase/qtbase-everywhere-src-5.13.1/configure -debug -eglfs -opengl es2 \
    -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=$toolchain1 \
    -sysroot $WORKINGDIR/sysroot -opensource -confirm-license -make libs \
    -extprefix $WORKINGDIR/sysroot/qt5 -hostprefix $WORKINGDIR/tools/build-tools \
    -pkg-config -no-use-gold-linker -v 





echo -e "\e[1;32mrun: make -j<number of cores>\e[0m" 
echo -e "\e[1;32mrun: make install\e[0m" 

