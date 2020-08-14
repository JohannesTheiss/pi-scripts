#!/bin/bash

### call this script from your qt-project-folder ### 
PIQMAKE=/run/media/johannes/Alles/fh/GPS_Logbook/Pi/raspi-qt/tools/build-tools/bin/qmake
EXECNAME="main"
PIUSER="pi"
PINAME="logbook"
TARGET_PATH=/home/pi/qt

echo -e "\e[1;32mdeploy qt to the pi....\e[0m" 
# and deploy new files
#rsync -avz $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 
#rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 


# build example
#cd qtbase/examples/opengl/qopenglwidget
#~/raspi/qt5/bin/qmake
#make

#scp qopenglwidget pi@raspberrypi.local:/home/pi


echo -e "\e[1;32mbuild qt-project....\e[0m" 
$PIQMAKE
make

echo -e "\e[1;32mcopy qt-project to RPI....\e[0m" 
# scp $DIR $PIUSER@$PINAME:$TARGET_PATH
rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" . $PIUSER@$PINAME:$TARGET_PATH

ssh $PIUSER@$PINAME -X $TARGET_PATH/$EXECNAME

