#!/usr/bin/env bash

# Test for interactiveness
[[ $- == *i* ]] || return

for file in ${HOME}/.bash/autoload/*; do
    source ${file}
done

if [[ -d ~/.bash_private ]]; then
    for file in ${HOME}/.bash_private/autoload/*; do
        source ${file}
    done
fi

source ${HOME}/.bash/bash-preexec.sh

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

#THIS MUST BE AT THE END OF DOTFILES FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
