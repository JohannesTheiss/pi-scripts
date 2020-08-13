#!/bin/bash

### CHANGE THESE SETTINGS IF NEEDED ###
HOSTNAME="logbook"
#LOCALE="de_DE.UTF-8"
#LAYOUT="de"
WIFICOUNTRY="DE"



# enable development sources 
echo -e "\e[1;32menable development sources....\e[0m" 
echo "deb-src http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi" >> /etc/apt/sources.list

#### updates #### 
echo -e "\e[1;32mmake updates...\e[0m" 
apt update
apt upgrade -y
# apt dist-upgrade -y
apt full-upgrade -y

#### setting ####
# set hostname
echo -e "\e[1;32mset hostname....\e[0m" 
raspi-config nonint do_hostname ${HOSTNAME} 

# set locale
# echo -e "\e[1;32mset locale....\e[0m" 
# raspi-config nonint do_change_locale ${LOCALE}

# keyboard layout
# echo -e "\e[1;32mset keyboard layout....\e[0m" 
# error on tty (dead_belowmacron)
# raspi-config nonint do_configure_keyboard ${LAYOUT} 

# set wifi country 
echo -e "\e[1;32mset wifi country....\e[0m" 
raspi-config nonint do_wifi_country ${WIFICOUNTRY}


#### reduce energy consumption #### 

# disable bluetooth
echo -e "\e[1;32mdisable bluetooth....\e[0m" 
systemctl disable hciuart.service
systemctl disable bluetooth.service


# Memory split more memory for the GPU
# RPI 3 b+ -> 1 GP RAM -> max. gpu_mem = 512 MB
# gpu_mem=16 # min -> add to config.txt


# add to /boot/config.txt
echo -e "\e[1;32madd to config.txt....\e[0m" 
cat << LINES >> /boot/config.txt
# disable bluetooth
dtoverlay=disable-bt
# disable rainbow splash screen on boot
disable_splash=1
# use fullscreen
disable_overscan=1
# disable HDMI
hdmi_blanking=1
hdmi_ignore_hotplug=1
hdmi_ignore_composite=1
LINES


### ssh setting ###
echo -e "\e[1;32mssh only allow pi-user....\e[0m" 
echo "AllowUsers pi" >> /etc/ssh/sshd_config
# sudo sshd -t # test the sshd_config 
systemctl restart sshd


### expand filesystem ###
echo -e "\e[1;32mexpand filesystem....\e[0m" 
canExpand=$(raspi-config nonint get_can_expand)
if [ $canExpand -ne 0 ]
then
    echo "can't expand filesystem"
    raspi-config nonint do_expand_rootfs
else
    echo "can't expand filesystem"
fi

# print setting  ... but why
#vcgencmd get_config int
#vcgencmd get_config str

# disable raspi-config 
systemctl disable raspi-config



# reboot
read -p "reboot? [y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
reboot
