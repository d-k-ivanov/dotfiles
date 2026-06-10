#!/usr/bin/env bash

# Normalize coreutils across platforms
platform=`uname`
case ${platform} in
    Linux )
        if [[ "$(lsb_release -rs 2>/dev/null)" == "26.04" ]]; then
            if command -v gnuls >/dev/null 2>&1; then
                unalias ls 2>/dev/null
                alias ls='gnuls '
                if [ -x /usr/bin/dircolors ]; then
                    alias ls='gnuls --color=auto '
                fi
            fi

            if command -v gnudir >/dev/null 2>&1; then
                unalias dir 2>/dev/null
                alias dir='gnudir '
                if [ -x /usr/bin/dircolors ]; then
                    alias dir='gnudir --color=auto '
                fi
            fi

            if command -v gnuvdir >/dev/null 2>&1; then
                unalias vdir 2>/dev/null
                alias vdir='gnuvdir '
                if [ -x /usr/bin/dircolors ]; then
                    alias vdir='gnuvdir --color=auto '
                fi
            fi
        else
            if [ -x /usr/bin/dircolors ]; then
                alias ls='ls --color=auto '
                alias dir='dir --color=auto '
                alias vdir='vdir --color=auto '
            fi
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
            alias dir='dir --color=auto '
            alias vdir='vdir --color=auto '
        fi
        ;;
esac
