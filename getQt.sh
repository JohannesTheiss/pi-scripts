#!/bin/bash

filename="qt-everywhere-src-5.15.0.tar.xz"
md5Hack="610a228dba6ef469d14d145b71ab3b88"


if [[ ! -e $filename ]]
then
    echo "get Qt 5.15"
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



