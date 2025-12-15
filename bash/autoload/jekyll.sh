#!/usr/bin/env bash

# Jekyll scripts.

# Check invocation
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: Bad invocation. This script is supposed to be sourced. Exiting..." >&2
    return 1 2>/dev/null || exit 1
fi

jkinit() {
    bundle install
    bundle exec jekyll build
}

jkpost() {
    local force=0
    while [[ $# -gt 0 ]]; do
        case "$1" in
        -f | --force)
            force=1
            shift
            ;;
        *)
            shift
            ;;
        esac
    done

    bundle exec jekyll build
    git add --all
    git commit -am "Post $(date +"%Y-%d-%m-%H-%M")"
    if [[ $force -eq 1 ]]; then
        git push --force
    else
        git push
    fi
}

jkserv() {
    bundle exec jekyll serve --incremental --host 0.0.0.0
}
