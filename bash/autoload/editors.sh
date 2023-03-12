#!/usr/bin/env bash

# alias vim='nvim'
# alias gvim='nvim-qt'

if command -v code-insiders >/dev/null
then
    alias icode="code-insiders"
else
    alias icode="code"
fi

alias ic="icode ."
alias ww="icode ~/OneDrive/Workspace"
