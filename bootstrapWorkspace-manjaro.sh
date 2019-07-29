#!/usr/bin/env bash
set -e
set -x

# Check if user has sudo privilege
sudo -v

# Script must be executed as root
if [ $USER = root ]
  then echo "Please DO NOT run this script as root!"
  exit
fi

# Update and upgrade
yes | pacman -Syu

# Install yay
sudo -H -u $USER sh -c '  
git clone https://aur.archlinux.org/yay.git
(cd yay && makepkg -si --noconfirm)
rm -rf yay
'

# Install wget and curl
pacman -S wget curl --noconfirm

# Install git, gitg and gitflow-avh
pacman -S git gitg --noconfirm
sudo -H -u $USER yay -S gitflow-avh --noconfirm

# Install tmux and tmux-xpanes
pacman -S tmux --noconfirm
sudo -H -u $USER yay -S tmux-xpanes --noconfirm

# Install direnv
yay -S direnv --noconfirm

# Install tree
pacman -S tree --noconfirm

# Install zsh
pacman -S zsh --noconfirm

# Install oh-my-zsh
rm -rf ~/.oh-my-zsh
sudo -H -u $USER sh -c '
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
'

# Install zsh-syntax-highlighting
sudo -H -u $USER sh -c '
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
'

# Change default shell to zsh
chsh -s $(which zsh) $USER

# Install silver searcher
pacman -S the_silver_searcher --noconfirm

# Install powerlevel9k
sudo -H -u $USER sh -c '
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
'

# Download pre-patched font
(cd /usr/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf)
fc-cache

# Install terminator
pacman -S terminator --noconfirm
sudo -H -u $USER sh -c '
mkdir -p ~/.config/terminator
cp .config/terminator/config ~/.config/terminator/config
'

# Install latest vim with lua/perl/python/clipboard support
pacman -S gvim --noconfirm

# Install vim-plug and install plugins 
sudo -H -u $USER sh -c '
cp .vimrc /home/$USER
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.vim/dirs/tmp ~/.vim/dirs/backups ~/.vim/dirs/undos 
vim +PlugInstall +qall
'

# set difftool to vimdiff
git config --global diff.tool vimdiff
git config --global difftool.prompt false
git config --global alias.d difftool

# Install Pyenv
sudo -H -u $USER sh -c '
curl https://pyenv.run | bash
echo 'PATH="$HOME/.pyenv/bin:$PATH"' >> /home/$USER/.zshrc
echo 'eval "$(pyenv init -)"' >> /home/$USER/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"' >> /home/$USER/.zshrc
'

# Install pyenv 3.7.4 via pyenv
sudo -H -u $USER sh -c '
~/.pyenv/bin/pyenv install 3.7.4
'

# Install Go
pacman -S go --noconfirm
sudo -H -u $USER sh -c '
vim +GoInstallBinaries +qall
'

# Install Chinese input method
pacman -Sy fcitx-configtool fcitx-gtk2 fcitx-gtk3 fcitx-qt5 fcitx-chewing --noconfirm
echo 'export GTK_IM_MODULE=fcitx' >> /etc/profile
echo 'export XMODIFIERS=@im=fcitx' >> /etc/profile
echo 'export QT_IM_MODULE=fcitx' >> /etc/profile

# Install sshuttle
pacman -S sshuttle --noconfirm

# Install virtualbox and vagrant 
pacman -S virtualbox --noconfirm
pacman -S linux$(uname -r | cut -d . -f 1-2 | sed 's/\.//')-virtualbox-host-modules --noconfirm

# Install monitoring tools
pacman -S htop bmon glances --noconfirm
sudo -H -u $USER yay -S tcptrack --noconfirm
sudo -H -u $USER yay -S sysstat --noconfirm

# copy .zshrc
sudo -H -u $USER cp .zshrc /home/$USER/.zshrc

# Enable and start sshd
systemctl enable sshd
systemctl start sshd

# Install docker
pacman -S docker --noconfirm
systemctl enable docker
systemctl start docker
usermod -aG docker $USER

# Install Dbeaver
yay -S dbeaver --noconfirm

# DONE
echo "All done, please restart your computer now!"
