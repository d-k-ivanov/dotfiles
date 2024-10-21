#!/usr/bin/env bash

umask 027

## Language settings
export LANG=en_US.UTF-8
export LC_ALL=$LANG
# export LC_ALL=C
export LC_COLLATE=C
export LC_CTYPE=$LANG
export LANGUAGE=$LANG
# export LC_CTYPE=C
# export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=00;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:ow=00;32:'

export EDITOR='vim'

# Colors in Vim and TMUX. Do not set this variables if you not shure why.
# https://wiki.archlinux.org/index.php/Home_and_End_keys_inot_working
#export TERM='screen-256color'
#export TERM='xterm-256color'

export GPG_TTY=$(tty)
export PYENV="$HOME/.pyenv"
export PYENV_HOME="$HOME/.pyenv"
export PYENV_ROOT="$HOME/.pyenv"

# Do not prompt using Windows native with WSL
export DONT_PROMPT_WSL_INSTALL='true'

# Finout linux distro
if [ -f /etc/os-release ]
then
    . /etc/os-release
    export OS_DISTRIBUTION=$NAME
elif type lsb_release >/dev/null 2>&1
then
    export OS_DISTRIBUTION=$(lsb_release -si)
elif [ -f /etc/lsb-release ]
then
    . /etc/lsb-release
    export OS_DISTRIBUTION=$DISTRIB_ID
else
    export OS_DISTRIBUTION=$(uname -s)
fi

[[ -f $HOME/.localenv ]] && source ~/.localenv
