#!/bin/bash

# . ist ein repo also nicht rsyncen
# usage: ./sync.sh <fromPath> <toPath>

USERNAME="pi"
#HOSTNAME="joker-pi"
HOSTNAME="192.168.2.117"
#TARGET=/home/${USERNAME}/scripts/

#rsync -avhe ssh --delete . ${USERNAME}@${HOSTNAME}:$TARGET
#rsync -av --delete . ${USERNAME}@${HOSTNAME}:$TARGET

numerOfArgs=$#
fromPath=$1
toPath=$2

# form path
if [[ $numerOfArgs -eq 2 && -d $fromPath ]]
then
    rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $fromPath ${USERNAME}@${HOSTNAME}:$toPath
else
    echo "fromPath or toPath doesn't exists"
fi

