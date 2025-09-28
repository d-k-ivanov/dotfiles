#!/usr/bin/env bash

# SDKMAN
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

function sdk-java-home-current()
{
    export JAVA_HOME=${SDKMAN_DIR}/candidates/java/current
}

function sdk-java-home-verion()
{
    if [ -z "$1" ]; then
        echo "Usage: sdk-java-home-version <version>"
        return 1
    fi

    if [ ! -d "${SDKMAN_DIR}/candidates/java/$1" ]; then
        echo "Version $1 not found in SDKMAN"
        return 1
    fi
    export JAVA_HOME=${SDKMAN_DIR}/candidates/java/$1
}

