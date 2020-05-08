#!/usr/bin/env bash

# set -x
set -euo pipefail

function command_exists() {
	command -v "$@" >/dev/null 2>&1
}

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
}

function source_file() {
  source ./scripts/base.sh
  echo 'source mac-setting'
  source ./scripts/mac-setting.sh
  echo 'source open-url'
  source ./scripts/open-url.sh
}

function exec_python() {
  echo 'link config'
  if command_exists 'python3'; then
    python3 ./scripts/links.py -fi
  else
    python ./scripts/links.py -fi
  fi
}

function source_install() {
  cd ./install
  echo 'brew install...'
  source ./brew.sh
  echo 'flutter install...'
  source ./flutter.sh
  echo 'vim install...'
  source ./vim.sh
  cd ../
}

function main() {
  source_install

  exec_python

  source_file
}

main
