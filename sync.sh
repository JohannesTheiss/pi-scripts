#!/bin/bash

# usage: ./sync.sh <fromPath> <toPath>


### CHANGE THESE SETTINGS IF NEEDED ###
USERNAME="pi"
HOSTNAME="logbook"

# args
numerOfArgs=$#
fromPath=$1
toPath=$2

if [[ $numerOfArgs -eq 2 && -d $fromPath ]]
then
    rsync --progress --delete -avz -e "ssh -i /home/johannes/.ssh/id_rsa" $fromPath ${USERNAME}@${HOSTNAME}:$toPath
else
    echo "fromPath or toPath doesn't exists"
fi
