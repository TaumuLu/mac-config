#!/usr/bin/env bash

# set -x
set -euo pipefail

MASTER="${HOME}/Master"
dirList=(
  "App"
  "Code"
  "Document"
  "Project"
  "Config"
  "Temp"
  "Test"
)

configDir=$MASTER/Config/mac-config

function init_folder() {
  for path in ${dirList[@]}; do
    local fullPath="$MASTER/$path"
    if [ ! -d $fullPath ]; then
      mkdir -p $fullPath
    fi
  done
}

function print_finish() {
  echo '-------------------'
  echo "finish $1"
  echo '-------------------'
}

function install() {
  if [ -d $configDir ]; then
    cd $configDir
    ./install.sh
  fi

  print_finish 'install.sh'
}

function main() {
  init_folder
  if [ ! -d $configDir ]; then
    mkdir -p $configDir
    git clone https://github.com/TaumuLu/mac-config.git $configDir --depth=1
  fi

  print_finish 'init.sh'

  install
}

main
