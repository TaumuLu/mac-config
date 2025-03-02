#!/usr/bin/env bash

# set -x
set -euo pipefail

cd ../dotfilts

files=(
  .bash_profile
  .bashrc
  .zshrc
  .zprofile
)

for file in ${files[@]}; do
  ln -sf $(get_pwd)/"$file" "$HOME"/"$file"
done

go_back_dir
