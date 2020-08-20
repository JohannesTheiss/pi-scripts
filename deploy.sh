#!/bin/bash

### call this script from your qt-project-folder ### 

### CHANGE THESE SETTINGS IF NEEDED ###
PIQMAKE=/home/johannes/fh/GPS_Logbook/Pi/raspi-qt/tools/build-tools/bin/qmake
EXECNAME="main"
PIUSER="pi"
PINAME="logbook"
TARGET_PATH=/home/pi/qt


echo -e "\e[1;32mbuild qt-project....\e[0m" 
$PIQMAKE
make

echo -e "\e[1;32mcopy qt-project to RPI....\e[0m" 
rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" . $PIUSER@$PINAME:$TARGET_PATH

# you may want to start your app remotely
ssh $PIUSER@$PINAME -X $TARGET_PATH/$EXECNAME
