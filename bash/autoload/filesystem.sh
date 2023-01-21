#!/usr/bin/env bash

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
        alias ls='ls --color=auto '
        ;;
    Darwin )
        alias ls='gls --color=auto '
        ;;
    FreeBSD )
        alias ls='ls -G '
        ;;
    MSYS_NT-10.0 )
        alias ls='ls --color=auto '
        ;;
esac

alias l='ls -CFh --group-directories-first '
alias la='ls -alh --group-directories-first '
alias ll='ls -alFh --group-directories-first '

fls()
{
    ls -l  "${@}" | grep -v ^d
}

flsa()
{
    ls -la "${@}" | grep -v ^d
}

dirs()
{
    ls -l  "${@}" | grep ^d
}

dirsa()
{
    ls -la "${@}" | grep ^d
}

# Navigation Shortcuts
alias   drop='cd ~/Dropbox'
alias   desk='cd ~/Desktop'
alias   docs='cd ~/Documents'
alias   down='cd ~/down'
alias     ws='cd ~/ws'
alias    wsm='cd ~/ws/my'
alias   wsdf='cd ~/ws/my/dotfiles'
alias   wsws='cd ~/OneDrive/Workspace'
alias  wsdsc='cd ~/ws/my/workstations'
alias wsconf='cd ~/ws/my/workstations'
alias wsmisc='cd ~/ws/misc'

alias  wsaw='cd ~/.config/awesome'
alias   wst='cd ~/ws/tmp'

# Straumann Shortcuts
alias     wsc='cd ~/ws/clearcorrect'
alias    wscc='cd ~/ws/clearcorrect/clinical/cc-dev'
alias   wscc1='cd ~/ws/clearcorrect/clinical/cc-dev1'
alias   wscc2='cd ~/ws/clearcorrect/clinical/cc-dev2'
alias   wscc3='cd ~/ws/clearcorrect/clinical/cc-dev3'
alias   wscc4='cd ~/ws/clearcorrect/clinical/cc-dev4'
alias   wsccv='cd ~/ws/clearcorrect/clinical/vcpkg'
alias    wscd='cd ~/ws/clearcorrect/devops'
alias    wsce='cd ~/ws/clearcorrect/service-exporters'

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
