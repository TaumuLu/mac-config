#!/usr/bin/env bash

# set -x
set -euo pipefail

function install_vundle() {
  local VUNDLE_HOME="$HOME/.vim/bundle/Vundle.vim"
  if [ ! -d $VUNDLE_HOME ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git $VUNDLE_HOME --depth=1
  fi
}

function install_spf13_vim() {
  local spf13VimPath=$HOME/.spf13-vim-3
  if [ ! -d $spf13VimPath ]; then
    curl https://j.mp/spf13-vim3 -L > spf13-vim.sh && sh spf13-vim.sh
  fi

  installPath=`get_pwd`/spf13-vim.sh
  if [ -f $installPath ]; then
    rm $installPath
  fi
}

function install_vimrc() {
  local vimrcPath=$HOME/.vim_runtime
  if [ ! -d $vimrcPath ]; then
    git clone https://github.com/amix/vimrc.git $vimrcPath --depth=1
  fi
  $vimrcPath/install_basic_vimrc.sh
}

function main() {
  install_vimrc
}

main
