#!/usr/bin/env bash

function lesscsv() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "File not found: $file"
        return 1
    fi

    column -s, -t < "$file" | less -#2 -N -S
}
