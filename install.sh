#!/bin/bash
#########################################################################
# Author: Johnny Shi
# Created Time: 2016-05-18 19:10:34
# File Name: install.sh
# Description: 
#########################################################################
VIMRC_PATH=$HOME/.vimrc
TMUX_CONF_PATH=$HOME/.tmux.conf
SSH_CONF_PATH=$HOME/.ssh/ssh_config

BASEDIR=$(dirname $0)
cd $BASEDIR
CURRENT_DIR=`pwd`

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
}

echo "Step1: backing up current vim config"
today=`date +%Y%m%d`
for i in $HOME/.vimrc
do
	[ -e $i ] && [ ! -L $i ] && mv $i $i.$today
done


echo "Step2: setting up symlinks"
lnif $CURRENT_DIR/vim/vimrc $VIMRC_PATH
lnif $CURRENT_DIR/tmux/tmux.conf $TMUX_CONF_PATH
lnif $CURRENT_DIR/ssh/ssh_config $SSH_CONF_PATH


echo "Link done!"


echo "Step3: update/install plugins using Vundle"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
exit 0
system_shell=$SHELL
export SHELL="/bin/sh"
vim -u $HOME/.vimrc.bundles +PlugInstall! +PlugClean! +qall
export SHELL=$system_shell


echo "Step4: compile YouCompleteMe"
echo "It will take a long time, just be patient!"
echo "If error,you need to compile it yourself"
echo "cd $CURRENT_DIR/bundle/YouCompleteMe/ && python install.py --clang-completer"
cd $CURRENT_DIR/bundle/YouCompleteMe/
git submodule update --init --recursive
if [ `which clang` ]   # check system clang
then
    python install.py --clang-completer --system-libclang   # use system clang
else
    python install.py --clang-completer
fi

echo "Install Done!"
