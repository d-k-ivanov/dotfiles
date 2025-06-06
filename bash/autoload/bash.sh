#!/usr/bin/env bash

export HISTCONTROL=ignoreboth
# export HISTCONTROL=ignorespace:erasedups

# Big history
export HISTSIZE=1000000
export HISTFILESIZE=1000000

# Dont save these commands in history
ignore_string='&:?:??:+(;):+(.)'
ignore_string+=':exit:pwd:clear:history*:reload:icod *:icode .:clion .:idea .'
ignore_string+=':g+(w):gw+(^):gg+(w):ggw+(^):g?:g??:g???'
ignore_string+=':ws:wsm::wsdf:wsdfb:wsdfp:wsws'
ignore_string+=':cd -:cd ..:cd ~:cd /'
ignore_string+=':*password*:*asplaintext*:*token*:*apikey*:*secret*:*access_key*'
ignore_string+=':*PASSWORD*:*ASPLAINTEXT*:*TOKEN*:*APIKEY*:*SECRET*:*ACCESS_KEY*'
ignore_string+=$':[ \t]*' # Character sequences of the form $’string’ are treated as a special kind of single quotes.
export HISTIGNORE="${ignore_string}"

# export HISTTIMEFORMAT='%s '
unset HISTTIMEFORMAT

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

# Write a multi line command in a single line
shopt -s cmdhist

# Approach 1
PROMPT_COMMAND="history -a"

# Approach 2: merge and reload history from all terminals
# The downdside of this approach is that it rewrite the history file every time a command is executed.
# history -n has to be there before history -w to read from .bash_history the commands saved from any other terminal,
# history -w has to be there to save the new history to the file after bash has checked if the command was a duplicate
# history -a must not be placed there instead of history -w because it will add to the file any new command, regardless of whether it was checked as a duplicate.
# history -c is also needed because it prevents trashing the history buffer after each command,
# history -r is needed to restore the history buffer from the file, thus finally making the history shared across terminal sessions.
# PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# Approach 3
# Merge history at exit
# function bashhistorymerge {
#     history -n; history -w; history -c; history -r;
# }
# trap bashhistorymerge EXIT
# PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

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
