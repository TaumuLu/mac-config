#!/usr/bin/env bash

# set -x
set -euo pipefail

MASTER="${HOME}/Master"

function initFolder() {
  local dirList=(
    ${MASTER}
    "${MASTER}/Code"
    "${MASTER}/Document"
    "${MASTER}/Project"
    "${MASTER}/Github"
    "${MASTER}/Temp"
    "${MASTER}/Test"
  )
  for path in ${dirList[@]}
  do
    if [ ! -d $path ]; then
      mkdir $path
    fi
  done
}

function main() {
  initFolder
}

main