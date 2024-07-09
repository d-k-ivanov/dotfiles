#!/usr/bin/env bash

# Test for interactiveness
[[ $- == *i* ]] || return

for file in ${HOME}/.bash/autoload/*; do
    source ${file}
done

if [[ -d ~/.bash_private ]] ; then
    for file in ${HOME}/.bash_private/autoload/*; do
        source ${file}
    done
fi

source ${HOME}/.bash/bash-preexec.sh


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
