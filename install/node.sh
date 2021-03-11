#!/usr/bin/env bash

# set -x
set -euo pipefail

npmList=(
  yarn
  npm-check-updates
  genfe-cli
  nrm
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
  local installList=`npm list -g --depth=0 | awk 'NR == 1 {next} {print $2}' | awk -F @ '{print $1}'`
  local nil=(`diff_arr "${npmList[*]}" "${installList[*]-}"`)
  if [ ! ${#nil[@]} -eq 0 ] && command_exists 'npm';then
    cyan "npm install -g ${nil[@]}"
    npm install -g ${nil[@]}
  fi
}

function main() {
  install_node

  npm_install
}

main
