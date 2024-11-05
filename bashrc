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

__conda_setup="$('${HOME}/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${HOME}/miniconda3/etc/profile.d/conda.sh" ]; then
        . "${HOME}/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="${HOME}/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
