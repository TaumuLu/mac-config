#!/usr/bin/env bash

# set -x
set -eo pipefail

function install_emscripten() {
  if [ -z "$EMSDK_HOME" ]; then
    EMSDK_HOME="$HOME/Master/App/emsdk"
  fi

  if [ ! -d $EMSDK_HOME ]; then
    git clone https://github.com/emscripten-core/emsdk.git $EMSDK_HOME --depth=1
    cd emsdk
    ./emsdk install latest
    ./emsdk activate latest
    source ./emsdk_env.sh
  fi
}

function main() {
  install_emscripten
}

main
