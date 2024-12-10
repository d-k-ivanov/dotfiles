#!/usr/bin/env bash

# alias gvim='nvim-qt'
# alias  vim='nvim'

idea() {
  local dir
  dir="${*:-./}"
  nohup /opt/intellij-idea-ultimate/bin/idea "$dir" >/dev/null 2>&1 &
  disown
}

clion() {
  local dir
  dir="${*:-./}"
  nohup /opt/clion/bin/clion "$dir" >/dev/null 2>&1 &
  disown
}

if command -v code-insiders >/dev/null
then
    alias icode="code-insiders"
else
    alias icode="code"
fi

alias ic="icode ."
alias ww="icode ~/ws/my/workspace"

# alias vss='clion .'
alias vssp="cp -rf ${WORKSPACE}/my/dotfiles/data/cmake/CMakePresets-Linux-GCC.json ./CMakePresets.json && icode ."
