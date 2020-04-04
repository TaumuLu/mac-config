#!/usr/bin/env bash

# set -x
set -euo pipefail

function command_exists() {
	command -v "$@" >/dev/null 2>&1
}

function install_flutter() {
  if [ ! -d $FLUTTER_HOME ]; then
    git clone https://github.com/flutter/flutter.git $FLUTTER_HOME -b stable --depth=1
  fi
  flutter doctor
}

function source_file() {
  source ./scripts/base.sh
  echo 'source mac-setting'
  source ./scripts/mac-setting.sh
  echo 'source open-url'
  source ./scripts/open-url.sh
}

function exec_python() {
  if command_exists 'python3'; then
    python3 ./scripts/links.py -f
  else
    python ./scripts/links.py -f
  fi
}

function main() {
  # source_file

  exec_python

  # install_flutter
}

main