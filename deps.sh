USERNAME="pi"

### setup VIM
# install vim and get my dotfils
apt install vim
# get my dotfils
git clone https://github.com/JohannesTheiss/dotfiles /home/${USERNAME}/Documents/
cp /home/${USERNAME}/Documents/dotfiles/vimrc ~/.vimrc


### install Qt 5.15
# install qmake
