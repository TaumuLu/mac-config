#!/usr/bin/env bash

# set -x
set -euo pipefail

# Homebrew
brewApp=(
  flow
  nginx
  fzf
  git
  git-flow
  nvm
  python
  mysql
  redis
  maven
  jenkins
  tmux
  highlight
  go
  tree
  watchman
  wget
  wrk
  the_silver_searcher
  # stow
  # fish
  # blueutil
  # openssl
  # vim
)

brewCaskList=(
  iterm2
  java
  docker
  google-chrome
  karabiner-elements
  qlcolorcode
  qlimagesize
  qlmarkdown
  quicklook-json
  hammerspoon
  typora
  scroll-reverser
  app-cleaner
  the-unarchiver
  switchhosts
  sourcetree

  sublime-text
  visual-studio-code
  android-studio
  # intellij-idea
  # cheatsheet
  # react-native-debugger
)

otherApp=(
  sizeup
  alfred
  GIF brewery
  steam
  QQ
  微信
  网易云音乐
  钉钉
  PDF Expert
  ShadowsockesX-NG
  iStat Menus

  reeder
  欧路词典
  BetterTouchTool
  kawa
  audacity
  hyper
  anki
  Contexts
  Movist pro
  Fohkuhs
  MindNode
  Bear
  DaisyDisk
  Cocoa
)

function get_app() {
  appList=()
  local i=0
  while read app
  do
    appList[$i]=${app%.app}
    let i+=1
  done < <(ls /Applications | grep .app$)
  return 0
}

function get_brew_list() {
  brewInstallList=()
  local i=0
  while read item
  do
    brewInstallList[$i]=$item
    let i+=1
  done < <(brew list)
}

function get_brew_cask_list() {
  brewCaskInstallList=()
  local i=0
  while read item
  do
    brewCaskInstallList[$i]=$item
    let i+=1
  done < <(brew cask list)
}

# function get_command_exists() {
#   while
#     (( $# > 0 ))
#   do
#     if command -v $1 >/dev/null 2>&1; then
#       echo "$1 command exists"
#     else
#       local len=${#brewInstallList[@]}
#       brewInstallList[$len]=$1
#       echo "111111 ${len}"
#       echo "$1 command no exists"
#     fi
#     shift
#   done
#   return 0
# }

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

function install_oh_my_zsh() {
  # oh-my-zsh
  if ! command_exists 'zsh'; then
    echo "install oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

function install_brew {
  # Homebrew
  if ! command_exists 'brew'; then
    echo "install Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  brew cleanup
}

function install_rvm {
  # rvm
  if ! command_exists 'rvm'; then
    echo "install rvm..."
    \curl -sSL https://get.rvm.io | bash -s stable
  fi

  local RVM="${HOME}/.rvm/user/db"
  local ruby_url="ruby_url=https://cache.ruby-china.com/pub/ruby"

  add_text $RVM $ruby_url
}

function pre_install() {
  # 所有已安装的应用
  appList=()
  # brew安装的应用
  brewInstallList=()
  # brew cask已安装的应用
  brewCaskInstallList=()

  get_app
}

function install() {
  pre_install

  install_brew
  install_rvm
  install_oh_my_zsh
  echo ${appList[@]}
  # get_brew_list
  # get_brew_cask_list

  # post_install
}

function post_install() {
  brew services start mysql
  brew services start nginx
  brew services start redis
}

install

