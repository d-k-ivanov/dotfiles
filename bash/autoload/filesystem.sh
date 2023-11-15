#!/usr/bin/env bash

test -r ${HOME}/.bash/dir_colors_nord && eval $(dircolors ${HOME}/.bash/dir_colors_nord)

alias        ..='cd ..'
alias       ...='cd ../..'
alias      ....='cd ../../..'
alias     .....='cd ../../../..'
alias    ......='cd ../../../../..'
alias   .......='cd ../../../../../..'
alias  ........='cd ../../../../../../..'

alias cdd='cd -'  # back to last directory

# Create a new directory and enter it
mkd()
{
    mkdir -p "$@" && cd "$@"
}

platform=`uname`
case ${platform} in
    Linux )
        if [ -x /usr/bin/dircolors ]; then
            alias ls='ls --color=auto '
            # alias dir='dir --color=auto '
            # alias vdir='vdir --color=auto '
        fi
        ;;
    Darwin )
        alias ls='gls --color=auto '
        ;;
    FreeBSD )
        alias ls='ls -G '
        ;;
    MSYS_NT-10.0 )
        if [ -x /usr/bin/dircolors ]; then
            alias ls='ls --color=auto '
            # alias dir='dir --color=auto '
            # alias vdir='vdir --color=auto '
        fi
        ;;
esac

alias l='ls -CFhH --group-directories-first '
alias la='ls -alhH --group-directories-first '
alias ll='ls -alFhH --group-directories-first '

fls()
{
    ls -lH  "${@}" | grep -v ^d
}

flsa()
{
    ls -laH "${@}" | grep -v ^d
}

dirs()
{
    ls -lH  "${@}" | grep ^d
}

dirsa()
{
    ls -laH "${@}" | grep ^d
}

# Navigation Shortcuts
alias   drop='cd ~/Dropbox'
alias   desk='cd ~/Desktop'
alias   docs='cd ~/Documents'
alias   down='cd ~/Downloads'
alias     ws='cd ~/ws'
alias    wsm='cd ~/ws/my'
alias   wsdf='cd ~/ws/my/dotfiles'
alias   wsws='cd ~/ws/my/workspace'
alias wsmisc='cd ~/ws/misc'
# alias   wsws='cd ~/OneDrive/Workspace'

case ${OS_DISTRIBUTION} in
    "Archlinux" )
        alias  wsdsc='cd ~/ws/my/workstations/arch'
        alias wsconf='cd ~/ws/my/workstations/arch'
        ;;

    "Ubuntu" )
        if [ ! "${WSL_DISTRO_NAME}" != "Ubuntu"   ]
        then
            alias  wsdsc='cd ~/ws/my/workstations/wsl'
            alias wsconf='cd ~/ws/my/workstations/wsl'
        else
            alias  wsdsc='cd ~/ws/my/workstations/ubuntu'
            alias wsconf='cd ~/ws/my/workstations/ubuntu'
        fi
        ;;

    * )
        alias  wsdsc='cd ~/ws/my/workstations'
        alias wsconf='cd ~/ws/my/workstations'
        ;;
esac

alias  wsaw='cd ~/.config/awesome'
alias   wst='cd ~/ws/tmp'
alias   wsv='cd ~/.vcpkg'

# Straumann Shortcuts
alias     wsc='cd ~/ws/clearcorrect'
alias    wscl='cd ~/ws/clearcorrect/clinical'
alias    wscc='cd ~/ws/clearcorrect/clinical/cc-dev'
alias   wscc1='cd ~/ws/clearcorrect/clinical/cc-dev1'
alias   wscc2='cd ~/ws/clearcorrect/clinical/cc-dev2'
alias   wscc3='cd ~/ws/clearcorrect/clinical/cc-dev3'
alias   wscc4='cd ~/ws/clearcorrect/clinical/cc-dev4'
alias   wsccv='cd ~/ws/vcpkg'
alias    wscd='cd ~/ws/clearcorrect/devops'
alias    wsce='cd ~/ws/clearcorrect/exporters'

# IRQ Shortcuts
alias   wsi='cd ~/ws/irq'
alias  wsic='cd ~/ws/irq/common'
alias  wsid='cd ~/ws/irq/devops'
alias  wsrm='cd ~/ws/irq/ml'
alias wsimm='cd ~/ws/irq/ml/irqml'

alias      crlf_fix='find ./ -type f -exec dos2unix {} \;'
alias   fix_dir_755='find ./ -type d -print -exec chmod 755 {} \;'
alias   fix_dir_750='find ./ -type d -print -exec chmod 750 {} \;'
alias   fix_dir_700='find ./ -type d -print -exec chmod 700 {} \;'
alias fix_files_644='find ./ -type f -print -exec chmod 644 {} \;'
alias fix_files_640='find ./ -type f -print -exec chmod 640 {} \;'
alias fix_files_600='find ./ -type f -print -exec chmod 600 {} \;'

alias fix_022='fix_dir_755 && fix_files_644'
alias fix_027='fix_dir_750 && fix_files_640'
alias fix_077='fix_dir_700 && fix_files_600'

# File size
alias fs="stat -c \"%s bytes\""

alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

alias mls="mount|column -t"

# find shorthand
f()
{
    find . -name "$1"
}

# List files in current directory and replace spaces with underscores
lsD()
{
    origIFS="${IFS}"
        IFS=''
        for str in `find . -maxdepth 1 -type f -name "* *" |sed 's#.*/##'`
        do
            echo ${str// /_}
        done
    IFS="${origIFS}"
}

find-rootfs()
{
    sudo find / -path /home/storage -prune -printf '' -o "$@"
}

find_core_dumps()
{
    sudo find / -path /home/storage -prune -printf '' -o                    \
        -type f -regextype posix-extended                                   \
        -regex '^.*core\.([0-9]{1}|[0-9]{2}|[0-9]{3}|[0-9]{4}|[0-9]{5})'    \
        -print "$@"
}

get-file-vars()
{
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    filename="${filename%.*}"
    echo "Basename:     ${filename}"
    echo "Filename:     ${filename%.*}"
    echo "Extention:    ${filename##*.}"
}

wsl-rebind-mounts()
{
    sudo mount --bind /mnt/c /c && sudo mount --bind /mnt/d /d
}

# rm aliases
alias rmf='rm -f '
alias rmrf='rm -rf '
