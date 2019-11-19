#!/bin/bash

sudo dpkg -i ~/cfg/cfg-files/fd_7.4.0_amd64.deb

sudo apt-get update
sudo apt-get install ack-grep
sudo apt-get install flake8
sudo apt-get install silversearcher-ag
sudo apt-get install tmux
sudo apt-get install vim

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install
ln -s ~/.fzf/bin/fzf ~/cfg-bin
(cd ~/cfg/cfg-files && git checkout .fzf.bash)

~/cfg/link
source ~/.bashrc
