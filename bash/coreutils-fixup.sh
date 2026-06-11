#!/usr/bin/env bash

# Normalize coreutils across platforms
platform=`uname`
case ${platform} in
    Linux )
        if [[ "$(lsb_release -rs 2>/dev/null)" == "26.04" ]]; then
            if command -v gnuls >/dev/null 2>&1; then
                unalias ls 2>/dev/null
                alias ls='LC_ALL=C LC_COLLATE=C gnuls '
                if [ -x /usr/bin/dircolors ]; then
                    alias ls='LC_ALL=C LC_COLLATE=C gnuls --color=auto '
                fi
            fi

            if command -v gnudir >/dev/null 2>&1; then
                unalias dir 2>/dev/null
                alias dir='LC_ALL=C LC_COLLATE=C gnudir '
                if [ -x /usr/bin/dircolors ]; then
                    alias dir='LC_ALL=C LC_COLLATE=C gnudir --color=auto '
                fi
            fi

            if command -v gnuvdir >/dev/null 2>&1; then
                unalias vdir 2>/dev/null
                alias vdir='LC_ALL=C LC_COLLATE=C gnuvdir '
                if [ -x /usr/bin/dircolors ]; then
                    alias vdir='LC_ALL=C LC_COLLATE=C gnuvdir --color=auto '
                fi
            fi
        else
            if [ -x /usr/bin/dircolors ]; then
                alias ls='LC_ALL=C LC_COLLATE=C ls --color=auto '
                alias dir='LC_ALL=C LC_COLLATE=C dir --color=auto '
                alias vdir='LC_ALL=C LC_COLLATE=C vdir --color=auto '
            fi
        fi
        ;;
    Darwin )
        alias ls='LC_ALL=C LC_COLLATE=C gls --color=auto '
        ;;
    FreeBSD )
        alias ls='LC_ALL=C LC_COLLATE=C ls -G '
        ;;
    MSYS_NT-10.0 )
        if [ -x /usr/bin/dircolors ]; then
            alias ls='LC_ALL=C LC_COLLATE=C ls --color=auto '
            alias dir='LC_ALL=C LC_COLLATE=C dir --color=auto '
            alias vdir='LC_ALL=C LC_COLLATE=C vdir --color=auto '
        fi
        ;;
esac
