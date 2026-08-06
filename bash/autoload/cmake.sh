#!/usr/bin/env bash

ninja_version=$(ninja --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+')
if [[ "$ninja_version" < "1.12" ]]; then
    export NINJA_STATUS="[%f/%t] "
else
    export NINJA_STATUS="[%w %f/%t %P] "
fi

cmake-presets-nj() {
    cp -rf "${HOME}/config/cmake/presets/CMakePresets-Linux-Ninja.json" $(pwd)/CMakePresets.json
}

cmake-presets-nj-gcc() {
    cp -rf "${HOME}/config/cmake/presets/CMakePresets-Linux-Ninja-GCC.json" $(pwd)/CMakePresets.json
}

cmake-presets-nj-clang() {
    cp -rf "${HOME}/config/cmake/presets/CMakePresets-Linux-Ninja-Clang.json" $(pwd)/CMakePresets.json
}

cgen-nj-debug() {
    cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=Debug -S $@
}

cgen-nj-release() {
    cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=Release -S $@
}

cgen-nj-reldebug() {
    cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -S $@
}

cgen-nj-debug-cl() {
    cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=clang-cl -DCMAKE_CXX_COMPILER=clang-cl -S $@
}

cgen-nj-release-cl() {
    cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang-cl -DCMAKE_CXX_COMPILER=clang-cl -S $@
}

cgen-nj-reldebug-cl() {
    cmake -G Ninja -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=clang-cl -DCMAKE_CXX_COMPILER=clang-cl -S $@
}

cgen-nj-debug-x() {
    cmake -G Ninja -B build/x64-Debug -DCMAKE_BUILD_TYPE=Debug -S $@
}

cgen-nj-release-x() {
    cmake -G Ninja -B build/x64-Release -DCMAKE_BUILD_TYPE=Release -S $@
}

cgen-nj-reldebug-x() {
    cmake -G Ninja -B build/x64-RelWithDebInfo -DCMAKE_BUILD_TYPE=RelWithDebInfo -S $@
}

cgen-nj-multi() {
    cmake -G "Ninja Multi-Config" -B build -S $@
}

cgen-nj-multi-debug() {
    cmake -G "Ninja Multi-Config" -B build/x64-Debug -DCMAKE_BUILD_TYPE=Debug -S $@
}

cgen-nj-multi-release() {
    cmake -G "Ninja Multi-Config" -B build/x64-Release -DCMAKE_BUILD_TYPE=Release -S $@
}

cgen-nj-multi-reldebug() {
    cmake -G "Ninja Multi-Config" -B build/x64-RelWithDebInfo -DCMAKE_BUILD_TYPE=RelWithDebInfo -S $@
}

cbuild-debug() {
    cmake --build build --config Debug $@
}

cbuild-release() {
    cmake --build build --config Release $@
}

cbuild-reldebug() {
    cmake --build build --config RelWithDebInfo $@
}

cbuild-debug-x() {
    cmake --build build/x64-Debug --config Debug $@
}

cbuild-release-x() {
    cmake --build build/x64-Release --config Release $@
}

cbuild-reldebug-x() {
    cmake --build build/x64-RelWithDebInfo --config RelWithDebInfo $@
}

alias cgen=cgen-nj-reldebug
alias cbuild=cbuild-reldebug

alias cgenbuild-debug="cgen-nj-debug . && cbuild-debug"
alias cgenbuild-release="cgen-nj-release . && cbuild-release"
alias cgenbuild-reldebug="cgen-nj-reldebug . && cbuild-reldebug"

alias cgenbuild=cgenbuild-reldebug
alias cgb=cgenbuild-reldebug
