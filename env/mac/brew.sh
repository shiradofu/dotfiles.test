#!/bin/bash

password="$1"

# shellcheck disable=SC2164
brew bundle --file "$(cd "$(dirname "$0")"; pwd)/Brewfile"

brew_interactive() {
  expect -c "
    set timeout -1
    spawn brew install $1
    expect \"\[Pp\]assword\"
    send -- \"${password}\n\"
  "
}

brew_interactive adobe-creative-cloud
brew_interactive session-manager-plugin

unset password
