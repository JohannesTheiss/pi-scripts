#!/bin/bash

#### call this script from build dir

WORKINGDIR=/home/johannes/Schreibtisch/raspi-qt
SOURCEDIR=$WORKINGDIR/qt-src
TARGET_QT_DIR=/usr/local/qt5

PIUSER="pi"
#PINAME="gpslogbook"
PINAME="192.168.2.120"

CORES=6

##### BUILD QT ######
echo -e "\e[1;32mbuild qt....\e[0m" 
$SOURCEDIR/qtbase/qtbase-everywhere-src-5.15.0/configure -release -eglfs -opengl es2 \
    -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=$WORKINGDIR/tools/gcc-toolchain/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- \
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

echo -e "\e[1;32mmake with $CORES cores....\e[0m" 
make -j$CORES
make install


# geht das ????
echo -e "\e[1;32mdeploy qt to the pi....\e[0m" 
# and deploy new files
#rsync -avz $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 
rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 
