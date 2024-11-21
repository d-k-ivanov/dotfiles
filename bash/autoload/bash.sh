#!/usr/bin/env bash

# No duplicates in history.
export HISTCONTROL=ignoredups:erasedups
# export HISTCONTROL=ignoreboth
# Big history
export HISTSIZE=1000000
export HISTFILESIZE=1000000
# export HISTTIMEFORMAT='%s '
unset HISTTIMEFORMAT

# Append to the history file, don't overwrite it
shopt -s histappend
# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

platform=$(uname)
if [ ! "${platform}" != "Darwin" ]; then
    # macOS Catalina: Suppress zsh warning
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# NOT WORKING :(
# Defaiult word delimiters
# export COMP_WORDBREAKS=';:,.[]{}()/\|^&*-=+`"–—―'
# Bash 4.0 word delimiters
# export COMP_WORDBREAKS='()<>;&|"'
# Defult
# export COMP_WORDBREAKS='"><=;|&(:'

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '\C-w:backward-kill-word'
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set show-all-if-ambiguous on'

alias reload='source ~/.bashrc && echo "Bash profile reloaded"'

# Bash as a login shell:
alias bash='bash -l '

hist_top() {
    history | awk '{a[$3]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -50
}
