#!/bin/bash

### call this script from your build dir ### 

### CHANGE THESE SETTINGS IF NEEDED ###
WORKINGDIR=/home/johannes/fh/GPS_Logbook/Pi/raspi-qt
SOURCEDIR=$WORKINGDIR/qt-src
TARGET_QT_DIR=$WORKINGDIR/qt5
PIUSER="pi"
PINAME="logbook"
#PINAME="192.168.2.120"

mkdir $TARGET_QT_DIR

# 1. C++17
toolchain1=$WORKINGDIR/tools/gcc-toolchain/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

# 2. work C++11 
#toolchain2=$WORKINGDIR/tools/rasp-toolchain/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-

# CORES=7

##### BUILD QT ######
echo -e "\e[1;32mbuild qt....\e[0m" 
#$SOURCEDIR/qtbase/qtbase-everywhere-src-5.13.1/configure -release -eglfs -opengl es2 \
#    -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=$toolchain1 \
#    -sysroot $WORKINGDIR/sysroot -opensource -confirm-license -make libs \
#    -prefix $TARGET_QT_DIR -extprefix $WORKINGDIR/sysroot/qt5 -hostprefix $WORKINGDIR/tools/build-tools \
#    -pkg-config -no-use-gold-linker -v 

$SOURCEDIR/qt-everywhere/qt-everywhere-src-5.13.1/configure -release -eglfs -opengl es2 \
    -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=$toolchain1 \
    -sysroot $WORKINGDIR/sysroot -opensource -confirm-license -make libs \
    -prefix $TARGET_QT_DIR -extprefix $WORKINGDIR/sysroot/qt5 -hostprefix $WORKINGDIR/tools/build-tools \
    -pkg-config -no-use-gold-linker -v 




# ./configure --help !!!
##  -release <-> -debug
# -recheck-all
# -no-gbm
# -prefix /opt/qt5 (local build of configure)
# -skip alles was nicht in modules ist
# linux-rasp-pi3-g++ 
# MYSQL_PREFIX=/opt/local/mysql-rpi-src -recheck-all -skip qtwebengine
# wo ist die toolchain ??

#echo -e "\e[1;32mmake with $CORES cores....\e[0m" 
#make -j$CORES
#make install

echo -e "\e[1;32mrun: make -j<number of cores>\e[0m" 
echo -e "\e[1;32mrun: make install\e[0m" 



# geht das ????
#echo -e "\e[1;32mdeploy qt to the pi....\e[0m" 
# and deploy new files
#rsync -avz $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 
#rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 
