#!/bin/bash
# shellcheck disable=SC1091

password=$1
git_name=$2
git_email=$3

i=0
msg()    { printf "\033[1;3$((i++%6+1))m%s\033[0m\n" "$1"; }
err()    { printf "\033[1;31m%s\033[0m\n" "$1" 1>&2; return 1; }
exists() { type "$1" > /dev/null 2>&1; }
is_mac() { echo "$OSTYPE" | grep darwin -q; }
is_wsl() { [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; }
brew_i() { for X; do msg $'\n🍺  Installing '"$X"$':\n'; brew install "$X"; done }

DOT_ROOT=$(cd "$(dirname "$0")" && pwd)
source "$DOT_ROOT/config/zsh/.zshenv"
TIME=$(date "+%F-%H%M")

#
# Deploy files
#
"$DOT_ROOT/bin/deploy" bin "$HOME" && hash -r
deploy config/zsh/.zshenv "$HOME"
deploy --all-in data   "$XDG_DATA_HOME"
deploy --all-in config "$XDG_CONFIG_HOME"
[ -d "$HOME/.putty" ] \
  && mv "$HOME/.putty" "$XDG_CONFIG_HOME/putty" \
  || mkdir -p "$XDG_CONFIG_HOME/putty"
[ -f ".gitconfig" ] && mv .gitconfig ".gitconfig.$TIME.bak"
git config --file "${XDG_CONFIG_HOME}/git/user.gitconfig" user.name "$git_name"
git config --file "${XDG_CONFIG_HOME}/git/user.gitconfig" user.email "$git_email"

#
# CLI tools
#
msg $'\n🍺  Installing zsh:\n'
expect -c "
  set timeout -1
  spawn brew install zsh
  expect \"\[Pp\]assword\"
  send -- \"${password}\n\"
"
if ! grep -xq "${HOMEBREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "$password" | sudo -S sh -c "printf '${HOMEBREW_PREFIX}/bin/zsh\n' >> /etc/shells"
fi
echo "$password" | chsh -s "$HOMEBREW_PREFIX/bin/zsh" >/dev/null 2>&1
mkdir -p "$XDG_STATE_HOME/zsh" && touch "$XDG_STATE_HOME/zsh/history"
git clone --depth 1 https://github.com/zdharma-continuum/zinit "${XDG_STATE_HOME}/zinit/zinit.git"

brew_i fzf
"${HOMEBREW_PREFIX}/opt/fzf/install" --xdg --completion --no-update-rc --no-key-bindings
brew_i cmake dateutils tree rg fd bat jq yq direnv tmux starship git-delta \
  yazi navi hyperfine tokei gh act awscli aws-cdk aws-sam-cli marp-cli

#
# Languages and tools
#
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
brew_i gcc llvm go protoc-gen-go python ruby php composer \
  node deno yarn npm-check-updates
# installed with mason.nvim doesn't support Apple Silicon
brew_i golangci-lint

brew_i docker docker-buildx docker-compose lazydocker
# https://github.com/abiosoft/colima/discussions/273
mkdir -p "$DOCKER_CONFIG/cli-plugins"
ln -sfn "$(which docker-compose)" "$DOCKER_CONFIG/cli-plugins/docker-compose"
ln -sfn "$(which docker-buildx)" "$DOCKER_CONFIG/cli-plugins/docker-buildx"
docker buildx install

brew_i protobuf

#
# NeoVim
#
brew_i vim nvim neovim-remote
mkdir -p "$XDG_CACHE_HOME"/vim/{undo,swap,backup}
git clone --filter=blob:none --branch=stable \
  https://github.com/folke/lazy.nvim.git \
  "$XDG_DATA_HOME/nvim/lazy/lazy.nvim"
msg $'\nInstalling neovim plugins...\n'
nvim --headless "+Lazy! sync" +qa
msg $'\n\nInstalling Treesitter Parsers...\n'
timeout 120 nvim --headless +TSUpdateSync
msg $'\nInstalling Language Servers...\n'
timeout 120 nvim --headless "+lua require('mason-lspconfig.ensure_installed')()"
msg $'\nInstalling Linting/Formatting tools...\n'
timeout 60 nvim --headless "+lua require('mason-null-ls.ensure_installed')()"
printf '\n'

msg $'\nsetting colorscheme:'
"$HOME/bin/chcs" --no-os

#
# Environment-spesific settings
#
if is_mac; then "$DOT_ROOT/env/mac/install.sh" "$password"; fi
if is_wsl; then "$DOT_ROOT/env/wsl/install.sh" "$password"; fi

longest="- $HOMEBREW_PREFIX/bin/zsh (to install plugins)"
printf '\n\n\n '
printf "%${#longest}s==\n\n" | tr " " "="
printf '  👏  \033[1;32mInstallation successfully completed! \033[0m\n\n'
cat << EOF
  What to do next:

  - $HOMEBREW_PREFIX/bin/zsh (to install plugins)
  - aws configure (access key is required)
  - gh auth login
EOF
printf '\n '
printf "%${#longest}s==\n\n" | tr " " "="

unset password
