#!/bin/bash

HOSTNAME="joker-pi"
LOCALE=de_DE.UTF-8
LAYOUT=de

# add pi to root group
# sudo usermod -aG root pi

# updates
apt update
apt upgrade -y

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

reboot
