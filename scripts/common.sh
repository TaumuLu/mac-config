#!/usr/bin/env bash

# set -x
set -euo pipefail

function command_exists() {
  command -v "$@" >/dev/null 2>&1
}

function app_exists() {
  local name="id of app \"$@\""
  osascript -e "$name" >/dev/null 2>&1
}

function check_file() {
  if [ ! -f $1 ]; then
    touch $1
  fi
}

function add_text() {
  check_file $1
  if ! (grep -c $2 $1 >/dev/null 2>&1) then
    echo $2 >> $1
  fi
}

function write_text() {
  check_file $1
  echo $2 > $1
}

function go_back_dir() {
  cd - >/dev/null 2>&1
}

function get_pwd() {
  cd $(dirname $0)
  local cPwd=`pwd`
  go_back_dir
  echo $cPwd
}

function diff_arr() {
  local arr=$1
  local arr2=$2
  local list=()
  local i=0
  for x in ${arr[@]}; do
    local isInstall=true
    for y in ${arr2[@]}; do
      if [ $x == $y ]; then
        isInstall=false
      fi
    done
    if [ $isInstall = true ]; then
      list[i]=$x
      let i+=1
    fi
  done
  echo ${list[@]-}
}
