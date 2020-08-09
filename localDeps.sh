#!/bin/bash

WORKINGDIR=/home/johannes/fh/GPS_Logbook/raspi-qt
SOURCEDIR=$WORKINGDIR/qt-src

PIUSER="admin"
PINAME="gpslogbook"

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



# get symlink-script from https://github.com/Kukkimonsuta/rpi-buildqt
# to replace symbolic links with relative links in sysroot ????
wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py -P $WORKINGDIR
chmod +x sysroot-relativelinks.py


#tar xf qt-everywhere-src-5.14.1.tar.xz
#cp -R qt-everywhere-src-5.14.1/qtbase/mkspecs/linux-arm-gnueabi-g++ qt-everywhere-src-5.14.1/qtbase/mkspecs/linux-arm-gnueabihf-g++
#sed -i -e 's/arm-linux-gnueabi-/arm-linux-gnueabihf-/g' qt-everywhere-src-5.14.1/qtbase/mkspecs/linux-arm-gnueabihf-g++/qmake.conf



# create sysroot directory
echo -e "\e[1;32mcreate sysroot directory....\e[0m" 
mkdir -p $WORKINGDIR/sysroot/{opt,usr}

echo -e "\e[1;32mcreate build directory....\e[0m" 
mkdir -p $WORKINGDIR/build


echo -e "\e[1;32mget pi libs....\e[0m" 
rsync -avz $PIUSER@$PINAME:/lib sysroot
rsync -avz $PIUSER@$PINAME:/usr/include sysroot/usr
rsync -avz $PIUSER@$PINAME:/usr/lib sysroot/usr
rsync -avz $PIUSER@$PINAME:/opt/vc sysroot/opt


echo -e "\e[1;32madjust symlinks to be relative....\e[0m" 
$WORKINGDIR/sysroot-relativelinks.py $WORKINGDIR/sysroot







# geht das ????
echo -e "\e[1;32mdeploy qt to the pi....\e[0m" 
rsync -avz $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 




