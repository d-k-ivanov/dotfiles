#!/usr/bin/env bash

# Increase NODE memory local limit
# export NODE_OPTIONS='--max-old-space-size=4096'

alias npm-update='npm install npm@latest -g'
alias npm-list-local='npm list --depth 0'
alias npm-list-global='npm list -g --depth 0'
alias npm-list-local-outdated='npm outdated --depth=0'
alias npm-list-global-outdated='npm outdated -g --depth=0'
alias npm-update-local='npm update'
alias npm-update-global='npm update -g'

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
