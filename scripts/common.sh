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
      if [[ $x == $y || $y == $x* ]]; then
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

## success
function blue() {
  echo -e "\033[34m$*\033[0m"
}

## exec
function green() {
  echo -e "\033[32m$*\033[0m"
}

## prompt
function cyan() {
  echo -e "\033[36m$*\033[0m"
}

## Error
function red() {
  echo -e "\033[31m\033[01m$*\033[0m"
}

## warning
function yellow() {
  echo -e "\033[33m\033[01m$*\033[0m"
}

## none
function white() {
  echo -e "\033[37m$*\033[0m"
}

# ## Error to warning with blink
# function bred() {
#     echo -e "\033[31m\033[01m\033[05m[ $1 ]\033[0m"
# }

# ## Error to warning with blink
# function byellow() {
#     echo -e "\033[33m\033[01m\033[05m[ $1 ]\033[0m"
# }
