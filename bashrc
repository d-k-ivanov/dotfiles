#!/usr/bin/env bash

# Test for interactiveness
[[ $- == *i* ]] || return

for file in ${HOME}/.bash/autoload/*; do
    source ${file}
done

source ${HOME}/.bash/bash-preexec.sh

# command -v pyenv >/dev/null && eval "$(pyenv init -)"
# command -v pyenv >/dev/null && eval "$(pyenv virtualenv-init -)"
