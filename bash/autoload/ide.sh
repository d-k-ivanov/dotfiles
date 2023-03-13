#!/usr/bin/env bash

# alias clion='sh /opt/clion-*/bin/clion.sh'
# alias idea='sh /opt/idea-*/bin/idea.sh'
# alias gvim='nvim-qt'
# alias  vim='nvim'

# alias cide='clion .'
# alias  ide='idea  .'

if command -v code-insiders >/dev/null
then
    alias icode="code-insiders"
else
    alias icode="code"
fi

alias ic="icode ."
alias ww="icode ~/OneDrive/Workspace"

# alias vss='clion .'
alias vssp="cp -rf ${WORKSPACE}/my/dotfiles/data/cmake/CMakePresets-Linux.json ./CMakePresets.json && icode ."
