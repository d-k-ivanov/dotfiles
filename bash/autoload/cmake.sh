#!/usr/bin/env bash

alias csp="cp -rf ${WORKSPACE}/my/dotfiles/data/cmake/CMakePresets-Linux-GCC.json ./CMakePresets.json"

alias cgen-nj="cmake -G Ninja -B build -S "
alias cgen-nj-d="cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=Debug -S "
alias cgen-nj-r="cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=Release -S "
alias cgen-nj-rd="cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -S "

alias cgen-nj-multi="cmake -G \"Ninja Multi-Config\" -B build -S "
alias cgen-nj-multi-d="cmake -G \"Ninja Multi-Config\" -B build -DCMAKE_BUILD_TYPE=Debug -S "
alias cgen-nj-multi-r="cmake -G \"Ninja Multi-Config\" -B build -DCMAKE_BUILD_TYPE=Release -S "
alias cgen-nj-multi-rd="cmake -G \"Ninja Multi-Config\" -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -S "

alias cgen=cgen-nj-rd

alias cbuild-d="cmake --build build --config Debug "
alias cbuild-r="cmake --build build --config Release "
alias cbuild-rd="cmake --build build --config RelWithDebInfo "

alias cbuild=cbuild-rd

alias cgenbuld-d="cgen-nj-d .   && cbuild-d"
alias cgenbuld-r="cgen-nj-r .   && cbuild-r"
alias cgenbuld-rd="cgen-nj-rd . && cbuild-rd"

alias cgenbuld=cgenbuld-rd
