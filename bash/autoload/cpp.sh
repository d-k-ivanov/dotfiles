#!/usr/bin/env bash

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# TODO: Refactor my CPP tempates before usage
# export CMAKE_GENERATOR="Ninja Multi-Config"
# export CMAKE_DEFAULT_BUILD_TYPE=Release

funcion use-gcc()
{
    export CC=gcc
    export CXX=g++
}

funcion use-gcc-13()
{
    export CC=gcc-13
    export CXX=g++-13
}

function use-gcc-14()
{
    export CC=gcc-14
    export CXX=g++-14
}

function use-gcc-15()
{
    export CC=gcc-15
    export CXX=g++-15
}

function use-clang()
{
    export CC=clang
    export CXX=clang++
}

function use-clang-10()
{
    export CC=clang-10
    export CXX=clang++-10
}

function use-clang-11()
{
    export CC=clang-11
    export CXX=clang++-11
}

function use-clang-12()
{
    export CC=clang-12
    export CXX=clang++-12
}

function use-clang-13()
{
    export CC=clang-13
    export CXX=clang++-13
}

function use-clang-14()
{
    export CC=clang-14
    export CXX=clang++-14
}

function use-clang-15()
{
    export CC=clang-15
    export CXX=clang++-15
}

function use-clang-16()
{
    export CC=clang-16
    export CXX=clang++-16
}

function use-clang-17()
{
    export CC=clang-17
    export CXX=clang++-17
}

function use-clang-18()
{
    export CC=clang-18
    export CXX=clang++-18
}

clang_format_all()
{
    find . -regex '.*\.\(cpp\|hpp\|cu\|c\|h\)' -exec clang-format -style=file -i {} \;
}

alias cppck="cppcheck -j8 --enable=all --force "
alias cppcki="cppck --inline-suppr "
alias cppckif="cppcki --suppressions-list=cppcheck-suppressions.txt "

cppckxml()
{
    cppck --xml --xml-version=2 $@ 2>cppcheck.xml
}

cppckixml()
{
    cppcki --xml --xml-version=2 $@ 2>cppcheck.xml
}

cppckifxml()
{
    cppckif --xml --xml-version=2 $@ 2>cppcheck.xml
}
