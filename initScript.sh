#!/bin/bash

# USERNAME="root"
HOSTNAME="joker-pi"
LOCALE=de_DE.UTF-8
LAYOUT=de
WIFICOUNTRY=DE
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# add pi to root group
# sudo usermod -aG root pi

#### updates #### 
apt update
apt upgrade -y
# apt dist-upgrade -y
apt full-upgrade -y

#### setting ####
# set new password

# set hostname
raspi-config nonint do_hostname ${HOSTNAME} 

# set locale
raspi-config nonint do_change_locale ${LOCALE}

# keyboard layout
raspi-config nonint do_configure_keyboard ${LAYOUT}

# set wifi country 
raspi-config nonint do_wifi_country ${WIFICOUNTRY}

#### reduce energy consumption #### 
# add to config.txt

# disable HDMI 
# add 
#disable_splash=1 # disable rainbow splash screen on boot
#hdmi_blanking=1
#hdmi_ignore_hotplug=1
#hdmi_ignore_composite=1
# add to /boot/config.txt

# disable bluetooth
systemctl disable hciuart.service
systemctl disable bluealsa.service
systemctl disable bluetooth.service


# may set overscan

# Memory split more memory for the GPU
# RPI 3 b+ -> 1 GP RAM -> max. gpu_mem = 512 MB
# gpu_mem=16 # min -> add to config.txt

# add deps.sh to autostart
# wie geht das dann wieder da raus? sed -i -e '$i sh ${DIR}/deps.sh &\n' rc.local


cat << LINES >> /boot/config.txt
# disable bluetooth
dtoverlay=disable-bt
# disable wifi (only in dev)
dtoverlay=disable-wifi
LINES



# expand filesystem
canExpand=$(raspi-config nonint get_can_expand)
if [ $canExpand -ne 0 ]
then
    echo "can't expand filesystem"
    raspi-config nonint do_expand_rootfs
else
    echo "can't expand filesystem"
fi


vcgencmd get_config int
vcgencmd get_config str

read -p "reboot? [y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
reboot
