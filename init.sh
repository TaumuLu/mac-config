#!/usr/bin/env bash

# set -x
set -euo pipefail

MASTER="${HOME}/Master"
dirList=(
  "Code"
  "Document"
  "Project"
  "Github"
  "Temp"
  "Test"
  "Config"
)

# noInstall=false

# for arg in "$@"; do
#   if [ $arg == '--no-install' ]; then
#     noInstall=true
#     continue
#   fi
# done

function init_folder() {
  for path in ${dirList[@]}; do
    local fullPath="$MASTER/$path"
    if [ ! -d $fullPath ]; then
      mkdir -p $fullPath
    fi
  done
}

function command_exists() {
  command -v "$@" >/dev/null 2>&1
}

function check_file() {
  if [ ! -f $1 ]; then
    touch $1
  fi
}

function add_text() {
  check_file $1
  if ! (grep -c $2 $1 >/dev/null 2>&1) then
    echo $2 >> $1
  fi
}

function write_text() {
  check_file $1
  echo $2 > $1
}

function install_brew {
  # Homebrew
  if ! command_exists 'brew'; then
    echo "install Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

function install_oh_my_zsh() {
  # oh-my-zsh
  local zshPath=${ZSH:-$HOME/.oh-my-zsh}
  if [ ! -d $zshPath ]; then
    echo "install oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi

  if [ -d $zshPath ]; then
    local zshCustomPath=${ZSH_CUSTOM:-$zshPath/custom}
    local autosuggestions=$zshCustomPath/plugins/zsh-autosuggestions
    local highlighting=$zshCustomPath/plugins/zsh-syntax-highlighting
    if [ ! -d $autosuggestions ]; then
      git clone https://github.com/zsh-users/zsh-autosuggestions ${autosuggestions} --depth=1
    fi
    if [ ! -d $highlighting ]; then
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${highlighting} --depth=1
    fi
  fi
}

function install_rvm {
  # rvm
  if ! command_exists 'rvm'; then
    echo "install rvm..."
    \curl -sSL https://get.rvm.io | bash -s stable
  fi

  local RVM_DB="${HOME}/.rvm/user/db"
  local RVM_USER=${RVM_DB%/*}
  local ruby_url="ruby_url=https://cache.ruby-china.com/pub/ruby"

  if [ ! -d $RVM_USER ]; then
    mkdir -p $RVM_USER
  fi

  add_text $RVM_DB $ruby_url
}

configDir=$MASTER/Config/mac-config
function pre_install() {
  init_folder
  if [ ! -d $configDir ]; then
    mkdir -p $configDir
    git clone https://github.com/TaumuLu/mac-config.git $configDir --depth=1
  fi
}

function install() {
  pre_install

  # install_rvm
  install_brew
  install_oh_my_zsh

  # post_install
}

function post_install() {
  if [ -d $configDir ]; then
    cd $configDir
    ./install.sh
  fi

  echo '-------------------'
  echo 'finish init.sh'
  echo '-------------------'
}

install
