#!/usr/bin/env bash

# set -x
set -euo pipefail

function install_flutter() {
  if [ ! -d $FLUTTER_HOME ]; then
    git clone https://github.com/flutter/flutter.git $FLUTTER_HOME -b stable --depth=1
    cyan 'flutter doctor'
    flutter doctor
  fi
}

function install_depot_tools() {
  if [ ! -d $DEPOT_TOOLS_HOME ]; then
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $DEPOT_TOOLS_HOME --depth=1
  fi
}

function main() {
  install_flutter
  # install_depot_tools
}

main
