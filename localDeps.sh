#!/bin/bash

WORKINGDIR=/home/johannes/fh/GPS_Logbook/raspi-qt
SOURCEDIR=$WORKINGDIR/qt-src

PIUSER="admin"
PINAME="gpslogbook"

TARGET_QT_DIR=/usr/local/qt5

# number of cores you like to use for the complication.
CORES=4

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
    wget -N https://download.qt.io/official_releases/qt/5.15/5.15.0/submodules/${modules[$i]} -P $SOURCEDIR

    # check hash
    echo -e "\e[1;32mcheck archive MD5 hash of ${modules[$i]}....\e[0m" 
    check=$(md5sum $SOURCEDIR/${modules[$i]})
    if [[ "$check" == "${hashes[$i]}  $SOURCEDIR/${modules[$i]}" ]]
    then
        echo -e "\e[1;32mMatch\e[0m" 
        echo "$check"
    else
        echo -e "\e[1;31mno match (Man-in-the-Middle... SHIT)\e[0m" 
        echo "$check != $md5Hack"
        exit 1
    fi

    # un-tar the source
    echo -e "\e[1;32mun-tar ${modules[$i]}....\e[0m" 
    tar -vxf $SOURCEDIR/${modules[$i]} -C $SOURCEDIR/${modules[$i]}
done





## ?? braucht man das???
#tar xf qt-everywhere-src-5.14.1.tar.xz
#cp -R qt-everywhere-src-5.14.1/qtbase/mkspecs/linux-arm-gnueabi-g++ qt-everywhere-src-5.14.1/qtbase/mkspecs/linux-arm-gnueabihf-g++
#sed -i -e 's/arm-linux-gnueabi-/arm-linux-gnueabihf-/g' qt-everywhere-src-5.14.1/qtbase/mkspecs/linux-arm-gnueabihf-g++/qmake.conf


#### SYSROOT ####
# create sysroot directory
echo -e "\e[1;32mcreate sysroot directory....\e[0m" 
mkdir -p $WORKINGDIR/sysroot/{opt,usr,qt5}

# get libs from pi
echo -e "\e[1;32mget pi libs....\e[0m" 
rsync -avz $PIUSER@$PINAME:/lib sysroot
rsync -avz $PIUSER@$PINAME:/usr/include sysroot/usr
rsync -avz $PIUSER@$PINAME:/usr/lib sysroot/usr
rsync -avz $PIUSER@$PINAME:/opt/vc sysroot/opt



#### TOOLCHAIN ####
echo -e "\e[1;32mcreate tools directory....\e[0m" 
mkdir -p $WORKINGDIR/tools/build-tools
# download toolchain
wget https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz \
        -P $WORKINGDIR/tools



# get symlink-script from https://github.com/Kukkimonsuta/rpi-buildqt
# to replace symbolic links with relative links in sysroot ????
wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py -P $WORKINGDIR
chmod +x $WORKINGDIR/sysroot-relativelinks.py
echo -e "\e[1;32madjust symlinks to be relative....\e[0m" 
$WORKINGDIR/sysroot-relativelinks.py $WORKINGDIR/sysroot




##### BUILD QT ######
echo -e "\e[1;32mcreate build directory....\e[0m" 
mkdir -p $WORKINGDIR/build

./configure -release -opengl es2 -device <rpi-version> \
            -device-option \
            CROSS_COMPILE=~/raspi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf- \
            -sysroot ~/raspi/sysroot -opensource -confirm-license -make libs \
            -prefix /usr/local/qt5pi -extprefix ~/raspi/qt5pi -hostprefix ~/raspi/qt5 -v


./configure -release -opengl es2 -device linux-rasp-pi4-v3d-g++ \
            -device-option \
            CROSS_COMPILE=~/$build_dir/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- \
            -sysroot ~/$build_dir/sysroot -opensource -confirm-license -make libs \
            -prefix /usr/local/qt5pi -extprefix ~/$build_dir/qt5pi -hostprefix ~/$build_dir/qt5 -v


# may best
./configure -release -opengl es2  -eglfs -device linux-rasp-pi4-v3d-g++ \
            -device-option \
            CROSS_COMPILE=/opt/RaspberryQt/tools/rpi-gcc-8.3.0/bin/arm-linux-gnueabihf- \
            -sysroot /opt/RaspberryQt/sysroot -prefix /usr/local/RaspberryQt 
            -opensource -confirm-license -skip qtscript -skip qtwayland 
            -skip qtwebengine -nomake tests -nomake examples -make libs 
            -pkg-config -no-use-gold-linker -v -recheck


./configure -release -opengl es2 -device linux-rasp-pi-g++ -device-option \
            CROSS_COMPILE=~/raspi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf- 
            -sysroot ~/raspi/sysroot -opensource -confirm-license -skip qtwayland 
            -skip qtlocation -skip qtscript -make libs -prefix /usr/local/qt5pi 
            -extprefix ~/raspi/qt5pi -hostprefix ~/raspi/qt5 -no-use-gold-linker -v -no-gbm

./configure -opengl es2 -device linux-rasp-pi3-g++ -device-option \
            CROSS_COMPILE=arm-linux-gnueabihf- -sysroot /opt/raspi/sysroot 
            -prefix /usr/local/qt5pi -opensource -confirm-license -plugin-sql-mysql 
            MYSQL_PREFIX=/opt/local/mysql-rpi-src -recheck-all -skip qtwebengine 
            -skip qtscript -make libs -no-use-gold-linker -v-all


# ./configure --help !!!
##  -release <-> -debug
$SOURCEDIR/qtbase-everywhere-src-5.15.0/configure -release -eglfs -opengl es2 \
    -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=$WORKINGDIR/tools/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- \
    -sysroot $WORKINGDIR/sysroot -opensource -confirm-license -make libs \
    -prefix $TARGET_QT_DIR -extprefix $WORKINGDIR/sysroot/qt5 -hostprefix $WORKINGDIR/tools/build-tools \
    -pkg-config -no-use-gold-linker -v 


# -recheck-all
# -no-gbm
# -prefix /opt/qt5 (local build of configure)
# -skip alles was nicht in modules ist
# linux-rasp-pi3-g++ 
# MYSQL_PREFIX=/opt/local/mysql-rpi-src -recheck-all -skip qtwebengine 
# wo ist die toolchain ??

make -j$CORES
make install


## für wayland
#framebuffer_depth=32
#gpu_mem=256
#dtoverlay=vc4-kms-v3d

# geht das ????
echo -e "\e[1;32mdeploy qt to the pi....\e[0m" 
# and deploy new files
rsync -avz $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 



