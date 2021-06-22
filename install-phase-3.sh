#!/bin/sh

# Backup
ln -s /mnt/backup ~/backup

# Git
git config --global user.name qqq0ppp
git config --global user.email qqq0ppp@protonmail.com
git config --global credential.helper store

# Emacs
git clone https://github.com/qqq0ppp/dotfiles.git ~/.dotfiles
mkdir ~/.config/emacs
ln -s ~/.dotfiles/emacs-init.el ~/.config/emacs/init.el
rm -r ~/.emacs.d

# Channels
mkdir ~/.config/guix
wget https://raw.githubusercontent.com/qqq0ppp/guix/main/channels.scm -P /home/me/.config/guix
guix pull

# Install packages
git clone https://github.com/qqq0ppp/guix.git
ls guix/packages/ | xargs -I tt guix package --install-from-file=guix/packages/tt
rm -r guix
