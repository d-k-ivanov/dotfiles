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
    alias e="code-insiders"
else
    alias e="code"
fi

alias ee="e ."
alias ww="e ~/ws/my/workspace"

# alias vss='clion .'
alias vssp="cp -rf ${WORKSPACE}/my/dotfiles/data/cmake/CMakePresets-Linux-GCC.json ./CMakePresets.json && ee "
