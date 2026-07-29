#!/usr/bin/env bash

# Check if sourced
(return 0 2>/dev/null) || {
    echo "Error: This script must be sourced (e.g., '. ai.sh'). Exiting..." >&2
    return 1 2>/dev/null || exit 1
}

function draco_decode() {
    if ! command -v draco_decoder &> /dev/null; then
        echo "Error: draco_decoder command not found. Please install the Draco decoder." >&2
        return 1
    fi

    local dir="${1:-.}"
    local format="${2:-stl}"

    find "$dir" -type f -name '*.drc' | while read -r file; do
        out="${file%.*}.$format"
        echo -e "\033[1;33mConverting: $file -> $out\033[0m"
        draco_decoder -i "$file" -o "$out"
    done
}

function draco_encode() {
    if ! command -v draco_encoder &> /dev/null; then
        echo "Error: draco_encoder command not found. Please install the Draco encoder." >&2
        return 1
    fi

    local dir="${1:-.}"
    local format="${2:-stl}"

    find "$dir" -type f -name "*.$format" | while read -r file; do
        out="${file%.*}.drc"
        echo -e "\033[1;33mConverting: $file -> $out\033[0m"
        draco_encoder -i "$file" -o "$out"
    done
}

alias drc_to_stl='draco_decode'
alias drc_to_ply='draco_decode -Format "ply"'
alias drc_to_obj='draco_decode -Format "obj"'

alias draco_to_stl='draco_decode'
alias draco_to_ply='draco_decode -Format "ply"'
alias draco_to_obj='draco_decode -Format "obj"'

alias stl_to_drc='draco_encode'
alias ply_to_drc='draco_encode -Format "ply"'
alias obj_to_drc='draco_encode -Format "obj"'

alias stl_to_draco='draco_encode'
alias ply_to_draco='draco_encode -Format "ply"'
alias obj_to_draco='draco_encode -Format "obj"'
