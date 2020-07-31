#!/bin/bash

USERNAME="pi"

### setup VIM
# install vim and get my dotfils
echo -e "\e[1;32minstall Vim....\e[0m" 
apt install vim -y
# get my dotfils
git clone https://github.com/JohannesTheiss/dotfiles /home/${USERNAME}/Documents/dotfiles
cp /home/${USERNAME}/Documents/dotfiles/vimrc /home/${USERNAME}/.vimrc

# set vim alias to bashrc
echo "alias v=\"vim\"" >> /home/${USERNAME}/.bashrc

### install xrdp server
echo -e "\e[1;32minstall xrdp....\e[0m" 
apt install xrdp -y

 
###### install Qt 5.15 #######
# install qmake
#apt install qt5-default -y
#apt install qml -y

### make GPS-Logbook folder ###
echo -e "\e[1;32mmake GPS-Logbook directory....\e[0m" 
gpsFolder=/usr/local/GPS-Logbook
mkdir $gpsFolder


### download qt 5.15 ###
sourceName="qt-everywhere-src-5.15.0.tar.xz"
if [[ ! -e $gpsFolder/$sourceName ]]
then
    echo -e "\e[1;32mGet Qt 5.15\e[0m" 
    wget https://download.qt.io/official_releases/qt/5.15/5.15.0/single/${sourceName} -P $gpsFolder
else
    echo -e "\e[1;32m$sourceName\e[0m already exists" 
fi

### check the md5 hash of the qt 5.15 tar
echo -e "\e[1;32mcheck archive MD5 hash....\e[0m" 
md5Hack="610a228dba6ef469d14d145b71ab3b88"
check=$(md5sum $gpsFolder/*.tar.xz)
if [[ "$check" == "$md5Hack  $gpsFolder/$sourceName" ]]
then
    echo -e "\e[1;32mMatch\e[0m" 
    echo "$check"
else
    echo -e "\e[1;31mno match\e[0m" 
    echo "$check != $md5Hack"
    exit 1
fi

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
 

