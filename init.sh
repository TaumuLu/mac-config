#!/usr/bin/env bash

# set -x
set -euo pipefail

# Homebrew
brewList=(
  flow
  nginx
  fzf
  git
  git-flow
  nvm
  python
  tree
  watchman
  the_silver_searcher
  highlight
  duti

  mysql
  redis
  maven
  # wget
  # go
  # wrk
  # jenkins
  # tmux
  # stow
  # fish
  # blueutil
  # openssl
  # vim
  # jenv
)

brewCaskList=(
  # java
  iterm2
  qlcolorcode
  qlimagesize
  qlmarkdown
  quicklook-json

  hammerspoon
  appcleaner
  switchhosts
  reactotron
  google-chrome
  karabiner-elements
  visual-studio-code
  sublime-text
  android-studio

  scroll-reverser
  omnidisksweeper
  # the-unarchiver

  # docker
  # sourcetree
  # typora

  # intellij-idea
  # cheatsheet
  # react-native-debugger
)

startList=(
  mysql
  nginx
  redis
)

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

noInstall=false

for arg in "$@"; do
  if [ $arg == '--no-install' ]; then
    noInstall=true
    continue
  fi
done

# 所有已安装的应用
appList=()
# brew安装的应用
brewInstallList=()
# brew cask已安装的应用
brewCaskInstallList=()

function init_folder() {
  for path in ${dirList[@]}; do
    local fullPath="$MASTER/$path"
    if [ ! -d $fullPath ]; then
      mkdir -p $fullPath
    fi
  done
}

function get_app() {
  appList=()
  local i=0
  while read app; do
    appList[$i]=${app%.app}
    let i+=1
  done < <(ls /Applications | grep .app$)
  return 0
}

function get_brew_list() {
  brewInstallList=()
  local i=0
  while read item; do
    brewInstallList[$i]=$item
    let i+=1
  done < <(brew list)
}

function get_brew_cask_list() {
  brewCaskInstallList=()
  local i=0
  while read item; do
    brewCaskInstallList[$i]=$item
    let i+=1
  done < <(brew cask list)
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

function diff_arr() {
  local arr=$1
  local arr2=$2
  local list=()
  local i=0
  for x in ${arr[@]}; do
    local isInstall=true
    for y in ${arr2[@]}; do
      if [ $x == $y ]; then
        isInstall=false
      fi
    done
    if [ $isInstall = true ]; then
      list[i]=$x
      let i+=1
    fi
  done
  echo ${list[@]-}
}

function brew_install() {
  local bil=(`diff_arr "${brewList[*]}" "${brewInstallList[*]-}"`)
  if [ ! ${#bil[@]} -eq 0 ];then
    echo "brew install ${bil[@]}"
    brew install ${bil[@]}
  fi

  # fzf
  $(brew --prefix)/opt/fzf/install
  if ! command_exists 'node'; then
    # nvm
    nvm install --lts
  fi

  local bcil=(`diff_arr "${brewCaskList[*]}" "${brewCaskInstallList[*]-}"`)
  if [ ! ${#bcil[@]} -eq 0 ];then
    echo "brew cask install ${bcil[@]}"
    brew cask install ${bcil[@]}
  fi

  # duti
  duti ./configs/duti/sublime.txt
  duti ./configs/duti/vscode.txt

  # java8
  brew tap adoptopenjdk/openjdk
  brew cask install adoptopenjdk8
  brew cask install adoptopenjdk11
  # 查看所有已安装java版本的信息
  /usr/libexec/java_home -V

  brew cleanup
}

function brew_services() {
  local serverList=`brew services list | awk 'NR == 1 {next} {print $1}'`
  for i in ${startList[@]}; do
    local isStart=true
    for j in ${serverList[@]}; do
      if [ $i == $j ]; then
        isStart=false
      fi
    done
    if [ $isStart = true ]; then
      brew services start $i
    fi
  done

  echo 'brew started services:'
  echo $serverList
}

function install_brew {
  # Homebrew
  if ! command_exists 'brew'; then
    echo "install Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if [ $noInstall = false ]; then
    brew_install
  fi
  brew_services
}

function install_oh_my_zsh() {
  # oh-my-zsh
  if ! command_exists 'zsh'; then
    echo "install oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi

  local autosuggestions=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  local highlighting=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  if [ ! -d $autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${autosuggestions} --depth=1
  fi
  if [ ! -d $highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${highlighting} --depth=1
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

function pre_install() {
  get_app
  get_brew_list
  get_brew_cask_list
}

function install() {
  pre_install

  # install_rvm
  install_brew
  install_oh_my_zsh

  post_install
}

function post_install() {
  init_folder
  local configDir=$MASTER/Config/mac-config
  if [ ! -d $configDir ]; then
    mkdir -p $configDir
    git clone https://github.com/TaumuLu/mac-config.git $configDir --depth=1
    cd $configDir
    ./install.sh
  fi

  echo '-------------------'
  echo 'finish installation'
  echo '-------------------'
}

install
