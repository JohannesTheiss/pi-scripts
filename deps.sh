#!/bin/bash

# $USER
USERNAME="pi"
QTVERSION="5.15"

###### ONLY DEV ######
### setup VIM
# install vim and get my dotfils
echo -e "\e[1;32minstall Vim....\e[0m" 
apt install vim -y
# get my dotfils
git clone https://github.com/JohannesTheiss/dotfiles /home/${USERNAME}/Documents/dotfiles
cp /home/${USERNAME}/Documents/dotfiles/vimrc /home/${USERNAME}/.vimrc

# set vim alias to bashrc
echo "alias v=\"vim\"" >> /home/${USERNAME}/.bashrc

# install pinout tool
# sudo apt install python3-gpiozero




#### make GPS-Logbook folder ####
echo -e "\e[1;32mcreate GPS-Logbook directory....\e[0m" 
gpsFolder=/usr/local/GPS-Logbook
mkdir $gpsFolder

 
###### install Qt #######

echo -e "\e[1;32minstall qt-dependencies....\e[0m" 
#apt install qt5-default -y ???
apt build-dep qt5-qmake
apt build-dep libqt5gui5

# optional
#apt build-dep libqt5webengine-data
#apt build-dep libqt5webkit5
# wiringpi libnfc-bin libnfc-dev fonts-texgyre libts-dev
# libbluetooth-dev bluez-tools gstreamer1.0-plugins* libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libopenal-data libsndio7.0 libopenal1 libopenal-dev pulseaudio


# gdbserver for remote debugging
apt install libudev-dev libinput-dev libts-dev libxcb-xinerama0-dev libxcb-xinerama0 gdbserver


## Add pi user to render group ????
# sudo gpasswd -a pi render


# create qt folder
echo -e "\e[1;32mcreate qt-directory....\e[0m" 
#apt install qt5-default -y ???
mkdir /usr/local/qt5
chown -R $USERNAME:$USERNAME /usr/local/qt5



# install X-server
#apt-get Install xserver-xorg
#apt-get Install xterm



# clean up
echo -e "\e[1;32mclean up....\e[0m" 
apt clean
apt autoremove
