#!/bin/bash

WORKINGDIR=/home/johannes/Schreibtisch/raspi-qt
SOURCEDIR=$WORKINGDIR/qt-src

PIUSER="pi"
#PINAME="gpslogbook"
PINAME="192.168.2.120"

TARGET_QT_DIR=/usr/local/qt5

# number of cores you like to use for the complication.
CORES=2

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
    folderName=${modules[$i]%%-*}
    mkdir $SOURCEDIR/$folderName
    tar -vxf $SOURCEDIR/${modules[$i]} -C $SOURCEDIR/$folderName
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
sysrootDir=$WORKINGDIR/sysroot
rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $PIUSER@$PINAME:/lib $sysrootDir
rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $PIUSER@$PINAME:/usr/include $sysrootDir/usr
rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $PIUSER@$PINAME:/usr/lib $sysrootDir/usr
rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $PIUSER@$PINAME:/opt/vc $sysrootDir/opt

#rsync -avz $PIUSER@$PINAME:/lib sysroot
#rsync -avz $PIUSER@$PINAME:/usr/include sysroot/usr
#rsync -avz $PIUSER@$PINAME:/usr/lib sysroot/usr
#rsync -avz $PIUSER@$PINAME:/opt/vc sysroot/opt



#### TOOLCHAIN ####
echo -e "\e[1;32mcreate tools directory....\e[0m" 
mkdir -p $WORKINGDIR/tools/build-tools
# download toolchain
wget -N https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz \
        -P $WORKINGDIR/tools

# un tar toolchain
mkdir $WORKINGDIR/tools/gcc-toolchain
tar -vxf $WORKINGDIR/tools/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz \
    -C $WORKINGDIR/tools/gcc-toolchain

### SYMLINK-SCRIPT ###
# get symlink-script from https://github.com/Kukkimonsuta/rpi-buildqt
# to replace symbolic links with relative links in sysroot ????
wget -N https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py -P $WORKINGDIR
chmod +x $WORKINGDIR/sysroot-relativelinks.py
echo -e "\e[1;32madjust symlinks to be relative....\e[0m" 
$WORKINGDIR/sysroot-relativelinks.py $WORKINGDIR/sysroot



##### BUILD QT ######
echo -e "\e[1;32mcreate build directory....\e[0m" 
mkdir -p $WORKINGDIR/build

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
