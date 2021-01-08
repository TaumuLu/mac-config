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
  blueutil

  mysql
  redis
  maven
  # go
  # wget
  # wrk
  # jenkins
  # tmux
  # stow
  # fish
  # openssl
  # vim
  # jenv
)

brewCaskList=(
  v2rayx
  iterm2
  snipaste

  hammerspoon
  appcleaner
  google-chrome
  google-chrome-canary
  karabiner-elements
  visual-studio-code

  qlcolorcode
  qlimagesize
  qlmarkdown
  quicklook-json

  switchhosts
  reactotron
  sublime-text
  # adoptopenjdk8
  adoptopenjdk/openjdk/adoptopenjdk8
  adoptopenjdk11
  # docker
  # tunnelblick

  # visual-studio
  # android-studio
  # java

  # dotnet-sdk

  # scroll-reverser
  # omnidisksweeper
  # keycastr
  # dash

  # the-unarchiver

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

# 所有已安装的应用
appList=()
# brew安装的应用
brewInstallList=()
# brew cask已安装的应用
brewCaskInstallList=()

function get_app() {
  appList=()
  local i=0
  for item in `ls /Applications | grep .app$`; do
    appList[$i]=${item%.app}
    let i+=1
  done;
}

function get_brew_list() {
  brewInstallList=()
  local i=0
  for item in `brew list`; do
    brewInstallList[$i]=$item
    let i+=1
  done;
}

function get_brew_cask_list() {
  brewCaskInstallList=()
  local i=0
  for item in `brew cask list`; do
    brewCaskInstallList[$i]=$item
    let i+=1
  done;
}

function brew_post_install() {
  # fzf
  if [ ! -f $HOME/.fzf.zsh ]; then
    $(brew --prefix)/opt/fzf/install
  fi
  # duti
  duti ../data/duti/sublime.txt
  duti ../data/duti/vscode.txt
  duti ../data/duti/iterm2.txt
}

function brew_install() {
  local bil=(`diff_arr "${brewList[*]}" "${brewInstallList[*]-}"`)
  if [ ! ${#bil[@]} -eq 0 ]; then
    cyan "brew install ${bil[@]}"
    brew install ${bil[@]}
    get_brew_list

    brew cleanup
  fi

  brew_post_install

  local bcil=(`diff_arr "${brewCaskList[*]}" "${brewCaskInstallList[*]-}"`)
  # java8
  brew tap homebrew/cask-versions
  brew tap adoptopenjdk/openjdk
  if [ ! ${#bcil[@]} -eq 0 ]; then
    local caskList=()
    local i=0
    for item in ${bcil[@]}; do
      local name=${item//-/' '}
      if [ "$item" == 'switchhosts' ]; then
        name=$name!
      fi
      if ! app_exists $name ; then
        caskList[$i]=${item}
        let i+=1
      fi
    done
    if [ ! ${#caskList[@]} -eq 0 ]; then
      cyan "brew cask install ${caskList[@]}"
      brew cask install ${caskList[@]}
      get_brew_cask_list

      brew cleanup
    fi
  fi

  # 查看所有已安装java版本的信息
  cyan 'all java versions'
  /usr/libexec/java_home -V

}

function brew_services() {
  local serverList=`brew services list | awk 'NR == 1 {next} {print $1}'`
  for i in ${startList[@]}; do
    # [[ ! command_exists $i ]] && continue

    local isStart=true
    for j in ${serverList[@]}; do
      if [ $i == $j ]; then
        isStart=false
        break
      fi
    done
    if [ $isStart = true ]; then
      for k in ${brewInstallList[@]}; do
        if [ $i == $k ]; then
          brew services start $i
          break
        fi
      done
    fi
  done

  cyan 'brew started services:'
  white $serverList
}

function install_brew {
  # Homebrew
  if ! command_exists 'brew'; then
    cyan "install Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  brew_install
  brew_services
}

function pre_install() {
  get_app
  get_brew_list
  get_brew_cask_list
}

function main() {
  pre_install

  install_brew
}

main
