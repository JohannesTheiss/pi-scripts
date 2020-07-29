USERNAME="pi"
HOSTNAME="joker-pi"
TARGET=/home/${USERNAME}/scripts/

#rsync -avhe ssh --delete . ${USERNAME}@${HOSTNAME}:$TARGET
#rsync -av --delete . ${USERNAME}@${HOSTNAME}:$TARGET


rsync --progress -avz -e "ssh -i /home/johannes/.ssh/id_rsa" . ${USERNAME}@${HOSTNAME}:$TARGET
