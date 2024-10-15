#!/bin/bash

msg() { printf "\033[1;3$((i++%6+1))m%s\033[0m\n" "$1"; }

MAC_ROOT=$(cd "$(dirname "$0")" && pwd)

msg $'\n🔑  Setting git credential helper:'
git config --file "${XDG_CONFIG_HOME}/git/credential.gitconfig" credential.helper osxkeychain
