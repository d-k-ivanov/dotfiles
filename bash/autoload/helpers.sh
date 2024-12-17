#!/usr/bin/env bash

print_error() {
    local R="\033[0;31m" # Red
    local ZZ="\033[0m"   # Reset
    printf "${R}${@}${ZZ}\n"
}

print_success() {
    local G="\033[0;32m" # Green
    local ZZ="\033[0m"   # Reset
    printf "${G}${@}${ZZ}\n"
}

show() {
    type $@
}

function select_from_list() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true; do
        # list all options (option list is zero-based)
        index=0
        for o in "${options[@]}"; do
            if [ "$index" == "$cur" ]; then
                echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
            else
                echo "  $o"
            fi
            ((index++))
        done
        read -s -n3 key               # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]]; then # up arrow
            ((cur--))
            ((cur < 0)) && ((cur = 0))
        elif [[ $key == $esc[B ]]; then # down arrow
            ((cur++))
            ((cur >= count)) && ((cur = count - 1))
        elif [[ $key == "" ]]; then # nothing, i.e the read delimiter - ENTER
            break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}
