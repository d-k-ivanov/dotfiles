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

