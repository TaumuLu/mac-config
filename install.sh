#!/usr/bin/env bash

# set -x
set -euo pipefail

source ./scripts/common.sh

function install_rvm {
  # rvm
  if ! command_exists 'rvm'; then
    cyan "install rvm..."
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

function install_oh_my_zsh() {
  # oh-my-zsh
  local zshPath=${ZSH:-$HOME/.oh-my-zsh}
  if [ ! -d $zshPath ]; then
    cyan "install oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    compaudit | xargs chmod g-w,o-w
    zsh
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

function pre_install() {
  if ! app_exists "V2RayX"; then
    local V2RayX=$HOME/Documents/App/V2RayX.app.zip
    if [ -f $V2RayX ]; then
      unzip $V2RayX -d /Applications
      red 'please subscribe V2RayX config'
      exit
    fi
  fi
}

function exec_python() {
  if command_exists 'python3'; then
    green "link config..."
    python3 ./scripts/links.py -fi
    blue 'link config done'
  fi

  cyan 'copy exec "source ~/.zshrc"'
}

function source_script() {
  cd ./scripts

  green 'source links...'
  source ./links.sh
  blue 'source links done'

  if ! command_exists 'brew'; then
    green 'source mac-setting'
    source ./mac-setting.sh
    green 'source open-url'
    source ./open-url.sh
  fi

  cd ../
}

function source_install() {
  cd ./install

  green 'brew install...'
  source ./brew.sh
  blue 'brew install done'

  green 'hammerspoon install...'
  source ./hammerspoon.sh
  green 'hammerspoon install done'

  green 'node install...'
  source ./node.sh
  blue 'node install done'

  green 'flutter install...'
  source ./flutter.sh
  blue 'flutter install done'

  green 'vim install...'
  source ./vim.sh
  blue 'vim install done'

  cd ../
}

function main() {
  source_script

  # pre_install
  # install_rvm
  install_oh_my_zsh
  source_install

  exec_python

  post_install
}

function copyApp() {
  local appFolder=$HOME/Documents/App/.app
  for file in `ls $appFolder`
  do
    local appName=${file%.*}
    local appDir="/Applications"
    if [ ! -d "$appDir/${file}" ]; then
      local appPath="$appFolder/$file"
      cp -R $appPath $appDir
      cyan "copy app: $file"
    else
      yellow "$file already installed"
    fi
  done
}

function genSSH() {
  local ssh="${HOME}/.ssh"
  if [ -d $ssh ]; then
    chmod -R 700 ~/.ssh/*
  else
    echo "Generating ssh key..."
    echo "Please enter the email you want to associate with your ssh key: \c"
    read email
    ssh-keygen -t rsa -C "$email"
    genSSH
  fi
}

function post_install() {
  copyApp

  # switchHosts data.json
  if [ ! -f ./configs/.SwitchHosts/data.json ]; then
    cp ./data/data.json ./configs/.SwitchHosts
  fi

  genSSH
}

main
