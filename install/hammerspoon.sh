#!/usr/bin/env bash

# set -x
set -euo pipefail

# npm
function get_config() {
  cd ../
  local hsConfig="`get_pwd`/configs/.hammerspoon"
  cd ./install
  if [ ! -d $hsConfig ]; then
    git clone https://github.com/TaumuLu/hammerspoon-config $hsConfig --depth=1
  fi

  cd $hsConfig
  git pull
  go_back_dir

  killall Hammerspoon || true
  open /Applications/Hammerspoon.app
}


function main() {
  get_config
}

main
