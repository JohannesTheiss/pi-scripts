USERNAME="pi"

### setup VIM
# install vim and get my dotfils
apt install vim -y
# get my dotfils
git clone https://github.com/JohannesTheiss/dotfiles /home/${USERNAME}/Documents/dotfiles
cp /home/${USERNAME}/Documents/dotfiles/vimrc /home/${USERNAME}/.vimrc

# set vim alias to bashrc
echo "alias v=\"vim\"" >> /home/${USERNAME}/.bashrc

### install xrdp server
apt install xrdp -y

 
### install Qt 5.15
# install qmake
apt-get install qt5-default -y
#apt install qml -y
