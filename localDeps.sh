#!/bin/bash

WORKINGDIR=/home/johannes/fh/GPS_Logbook/raspi-qt
SOURCEDIR=/home/johannes/fh/GPS_Logbook/raspi-qt/qt-src

# ssh-key stuff ....

##### create working directory #####
echo -e "\e[1;32mcreate Working directory....\e[0m" 
mkdir -p $WORKINGDIR 

echo -e "\e[1;32mcreate Source directory....\e[0m" 
mkdir -p $SOURCEDIR 

##### download qt 5.15 #####
# see git: https://code.qt.io/cgit/qt/qtbase.git
# you can: git clone git://code.qt.io/qt/qtbase.git -b <qt-version>
# or 

# download the .tar
echo -e "\e[1;32mGet Qt 5.15....\e[0m" 
#wget http://download.qt.io/archive/qt/5.14/5.14.1/single/qt-everywhere-src-5.14.1.tar.xz -P $WORKINGDIR
#sourceName="qt-everywhere-src-5.15.0.tar.xz" # 565M   610a228dba6ef469d14d145b71ab3b88

# Modules
modules=("qtbase-everywhere-src-5.15.0.tar.xz")
hashes=("6be4d7ae4cd0d75c50b452cc05117009")

# single (all in one)
#wget -N https://download.qt.io/official_releases/qt/5.15/5.15.0/single/${sourceName} -P $WORKINGDIR


# install submodules
for i in ${!modules[@]}; do
    # download
    echo -e "\e[1;32mdownload ${modules[$i]}....\e[0m" 
    wget -N https://download.qt.io/official_releases/qt/5.15/5.15.0/submodules/${modules[$i]} -P $WORKINGDIR

    # check hash
    echo -e "\e[1;32mcheck archive MD5 hash of ${modules[$i]}....\e[0m" 
    check=$(md5sum $SOURCEDIR/${modules[$i]})
    if [[ "$check" == "${hashes[$i]}  $SOURCEDIR/${modules[$i]}" ]]
    then
        echo -e "\e[1;32mMatch\e[0m" 
        echo "$check"
    else
        echo -e "\e[1;31mno match (SHIT... Man-in-the-Middle)\e[0m" 
        echo "$check != $md5Hack"
        exit 1
    fi
done



# get symlink-script from https://github.com/Kukkimonsuta/rpi-buildqt
# to replace symbolic links with relative links in sysroot ????
wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py -P $WORKINGDIR
chmod +x sysroot-relativelinks.py
#./sysroot-relativelinks.py sysroot

#tar xf qt-everywhere-src-5.14.1.tar.xz
#cp -R qt-everywhere-src-5.14.1/qtbase/mkspecs/linux-arm-gnueabi-g++ qt-everywhere-src-5.14.1/qtbase/mkspecs/linux-arm-gnueabihf-g++
#sed -i -e 's/arm-linux-gnueabi-/arm-linux-gnueabihf-/g' qt-everywhere-src-5.14.1/qtbase/mkspecs/linux-arm-gnueabihf-g++/qmake.conf







### un-tar the source
echo -e "\e[1;32mun-tar the source....\e[0m" 
tar -vxf $gpsFolder/$sourceName -C $gpsFolder

echo -e "\e[1;32mget mkspecs configuration files....\e[0m" 
git clone https://github.com/oniongarlic/qt-raspberrypi-configuration.git $gpsFolder/qt-raspberrypi-configuration
# FIX VERSION !!!
#cd qt-raspberrypi-configuration && make install DESTDIR=$gpsFolder/qt-everywhere-src-5.15.0
make -C $gpsFolder/qt-raspberrypi-configuration install DESTDIR=$gpsFolder/qt-everywhere-src-5.15.0


apt update
apt install build-essential libfontconfig1-dev libdbus-1-dev libfreetype6-dev libicu-dev libinput-dev libxkbcommon-dev libsqlite3-dev libssl-dev libpng-dev libjpeg-dev libglib2.0-dev libraspberrypi-dev -y


echo -e "\e[1;32mmake build dir....\e[0m" 

mkdir $gpsFolder/gt-raspberrypi-configuration/build 
#cd build
