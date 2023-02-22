#!/usr/bin/env bash

# set -x
set -euo pipefail

# source ./scripts/common.sh

function install_rvm() {
  if ! command_exists 'rvm'; then
    \curl -sSL https://get.rvm.io | bash -s stable
  fi

  cyan 'rvm is already installed'
}

# https://gems.ruby-china.com/
function install_gem() {
  gem update --system
  cyan "gem version: "`gem -v`

  gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
  gem sources -l
}

function install_pods() {
  if ! command_exists 'pod'; then
    sudo gem install cocoapods
  fi

  cyan "pod version: "`pod --version`
}

function main() {
  install_rvm

  install_gem

  install_pods
}

main
