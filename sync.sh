USERNAME="pi"
HOSTNAME="joker-pi"
TARGET=/home/${USERNAME}/scripts/

rsync -avhe ssh . ${USERNAME}@${HOSTNAME}:$TARGET
