#!/bin/bash

USERNAME="pi"

### setup VIM
# install vim and get my dotfils
apt install vim -y
# get my dotfils
git clone https://github.com/JohannesTheiss/dotfiles /home/${USERNAME}/Documents/dotfiles
cp /home/${USERNAME}/Documents/dotfiles/vimrc /home/${USERNAME}/.vimrc

# set vim alias to bashrc
echo "alias v=\"vim\"" >> /home/${USERNAME}/.bashrc

### install xrdp server
apt install xrdp -y

 
###### install Qt 5.15 #######
# install qmake
#apt install qt5-default -y
#apt install qml -y


filename="qt-everywhere-src-5.15.0.tar.xz"
md5Hack="610a228dba6ef469d14d145b71ab3b88"

if [[ ! -e $filename ]]
then
    echo -e "\e[1;32mGet Qt 5.15\e[0m" 
    wget https://download.qt.io/official_releases/qt/5.15/5.15.0/single/${filename}
else
    echo -e "\e[1;32m$filename\e[0m already exists" 
fi

echo "check archive MD5 hash"
check=$(md5sum *.tar.xz)

if [[ "$check" == "$md5Hack  $filename" ]]
then
    echo -e "\e[1;32mMatch\e[0m" 
    echo "$check"
else
    echo -e "\e[1;31mno match\e[0m" 
    exit 1
fi

