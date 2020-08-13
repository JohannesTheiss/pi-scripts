#!/bin/bash

# $USER
# USERNAME="pi"

###### ONLY DEV ######
### setup VIM
# install vim and get my dotfils
echo -e "\e[1;32minstall Vim....\e[0m" 
apt install vim -y
# get my dotfils
#git clone https://github.com/JohannesTheiss/dotfiles /home/$USER/dotfiles
#cp /home/$USER/dotfiles/vimrc /home/$USER/.vimrc

# set vim alias to bashrc
# echo "alias v=\"vim\"" >> /home/$USER/.bashrc


#### make GPS-Logbook folder (deploy folder) ####
echo -e "\e[1;32mcreate GPS-Logbook directory....\e[0m" 
gpsFolder=/usr/local/GPS-Logbook
mkdir $gpsFolder

 
###### install Qt #######
echo -e "\e[1;32minstall qt-dependencies....\e[0m" 
#apt install qt5-default -y ???
apt build-dep qt5-qmake -y
apt build-dep libqt5gui5 -y

# optional
#apt build-dep libqt5webengine-data
#apt build-dep libqt5webkit5
# wiringpi libnfc-bin libnfc-dev fonts-texgyre libts-dev
# libbluetooth-dev bluez-tools gstreamer1.0-plugins* libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libopenal-data libsndio7.0 libopenal1 libopenal-dev pulseaudio


# gdbserver for remote debugging
apt install libudev-dev libinput-dev libts-dev libxcb-xinerama0-dev libxcb-xinerama0 gdbserver -y


## Add pi user to render group ????
# sudo gpasswd -a pi render


# create qt folder
echo -e "\e[1;32mcreate qt-directory....\e[0m" 
mkdir /usr/local/qt5
chown -R $USER:$USER /usr/local/qt5



# install X-server
# xorg to get: startx, xinit
apt install xorg -y


# clean up
echo -e "\e[1;32mclean up....\e[0m" 
apt clean -y
apt autoremove -y
