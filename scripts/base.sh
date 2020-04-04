#!/usr/bin/env bash

# set -x
set -euo pipefail

# ssh
if [ ! -e "$HOME/.ssh/id_rsa.pub" ]; then
  echo "Generating ssh key..."
  echo "Please enter the email you want to associate with your ssh key: \c"
  read email
  ssh-keygen -t rsa -C "$email"
fi
