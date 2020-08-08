#!/bin/bash

HOSTNAME="joker-pi"
LOCALE=de_DE.UTF-8
LAYOUT=de

# add pi to root group
# sudo usermod -aG root pi

# updates
apt update
apt upgrade -y
# apt dist-upgrade -y

# set hostname
raspi-config nonint do_hostname ${HOSTNAME} 

# set locale and keyboard layout
raspi-config nonint do_change_locale ${LOCALE}
raspi-config nonint do_configure_keyboard ${LAYOUT}

# expand filesystem
canExpand=$(raspi-config nonint get_can_expand)
if [ $canExpand -ne 0 ]
then
    echo "can't expand filesystem"
    raspi-config nonint do_expand_rootfs
else
    echo "can't expand filesystem"
fi


#### reduce energy consumption #### 
# disable HDMI 
# add 
#disable_splash=1 # disable rainbow splash screen on boot
#hdmi_blanking=1
#hdmi_ignore_hotplug=1
#hdmi_ignore_composite=1
# add to /boot/config.txt

# disable bluetooth
#echo "dtoverlay=disable-bt" >> /boot/config.txt
#systemctl disable hciuart.service
#systemctl disable bluealsa.service
#systemctl disable bluetooth.service

# disable wifi (only in dev)
#echo "dtoverlay=disable-wifi" >> /boot/config.txt


# install pinout tool
# sudo apt install python3-gpiozero

reboot
