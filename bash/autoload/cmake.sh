#!/usr/bin/env bash

cmake-presets-nj() {
    cp -rf "${HOME}/config/cmake/presets/CMakePresets-Linux-Ninja.json" $(pwd)/CMakePresets.json
}

cmake-presets-nj-gcc() {
    cp -rf "${HOME}/config/cmake/presets/CMakePresets-Linux-Ninja-GCC.json" $(pwd)/CMakePresets.json
}

cmake-presets-nj-clang() {
    cp -rf "${HOME}/config/cmake/presets/CMakePresets-Linux-Ninja-Clang.json" $(pwd)/CMakePresets.json
}

cgen-nj() {
    cmake -G Ninja -B build -S $@
}

cgen-nj-multi() {
    cmake -G "Ninja Multi-Config" -B build -S $@
}

cgen-nj-db() {
    cmake -G Ninja -B build/x64-Debug -DCMAKE_BUILD_TYPE=Debug -S $@
}

cgen-nj-rl() {
    cmake -G Ninja -B build/x64-Release -DCMAKE_BUILD_TYPE=Release -S $@
}

cgen-nj-rd() {
    cmake -G Ninja -B build/x64-RelWithDebInfo -DCMAKE_BUILD_TYPE=RelWithDebInfo -S $@
}

cgen-nj-multi-db() {
    cmake -G "Ninja Multi-Config" -B build/x64-Debug -DCMAKE_BUILD_TYPE=Debug -S $@
}

cgen-nj-multi-rl() {
    cmake -G "Ninja Multi-Config" -B build/x64-Release -DCMAKE_BUILD_TYPE=Release -S $@
}

cgen-nj-multi-rd() {
    cmake -G "Ninja Multi-Config" -B build/x64-RelWithDebInfo -DCMAKE_BUILD_TYPE=RelWithDebInfo -S $@
}

cbuild-db() {
    cmake --build build/x64-Debug --config Debug $@
}

cbuild-rl() {
    cmake --build build/x64-Release --config Release $@
}

cbuild-rd() {
    cmake --build build/x64-RelWithDebInfo --config RelWithDebInfo $@
}

alias cgen=cgen-nj-rd
alias cbuild=cbuild-rd

alias cgenbuld-db="cgen-nj-db . && cbuild-db"
alias cgenbuld-rl="cgen-nj-rl . && cbuild-rl"
alias cgenbuld-rd="cgen-nj-rd . && cbuild-rd"

alias cgenbuld=cgenbuld-rd
alias cgb=cgenbuld-rd
