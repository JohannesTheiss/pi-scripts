#!/bin/bash

# geht das ????
echo -e "\e[1;32mdeploy qt to the pi....\e[0m" 
# and deploy new files
#rsync -avz $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 
rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $WORKINGDIR/build $PIUSER@$PINAME:/usr/local/qt5 
