#!/usr/bin/env bash

# set -x
set -euo pipefail

npmList=(
  yarn
  npm-check-updates
)

# node
function install_node() {
  if ! command_exists 'node'; then
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
    nvm install --lts
  fi
}

# npm
function npm_install() {
  if command_exists 'npm'; then
    echo "npm install -g ${npmList[@]}"
    npm install -g ${npmList[@]}
  fi
}

function main() {
  install_node

  npm_install
}

main
