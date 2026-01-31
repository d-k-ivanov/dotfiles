#!/usr/bin/env bash

# "git commit only"
# Commits only what's in the index (what's been "git add"ed).
# When given an argument, uses that for a message.
# With no argument, opens an editor that also shows the diff (-v).
gco() {
    if [ -z "$1" ]; then
        git commit -v
    elif [ -z "$2" ]; then
        git commit "$1"
    else
        git commit "$1" -m "$2"
    fi
}

# "git commit all"
# Commits all changes, deletions and additions.
# When given an argument, uses that for a message.
# With no argument, opens an editor that also shows the diff (-v).
gca() {
    git add --all && gco "$1"
}

# "git get"
# Clones the given repo and then cd:s into that directory.
gget() {
    git clone "$1" && cd $(basename "$1" .git)
}

get_repo_with_target() {
    if [ -z "$1" ] || [ $2 ]; then
        echo "You should enter repo URI."
        echo "Usage: get_repo_with_target <repo_url>"
        echo
    else
        scheme=$(python3 -c "from urllib.parse import urlparse; uri='${1}'; result = urlparse(uri); print(result.scheme)")
        if [[ ${scheme} = "https" ]]; then
            target=$(python3 -c "from urllib.parse import urlparse; import os.path; uri='${1}'; result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.dirname(path[0]) + '-' + os.path.basename(path[0]))")
        else
            target=$(python3 -c "from urllib.parse import urlparse; import os.path; uri='${1}'; result = urlparse(uri); path = os.path.splitext(result.path.split(':', 1)[-1]); print(os.path.dirname(path[0]) + '-' + os.path.basename(path[0]))")
        fi
        git clone --recurse-submodules "${1}" "$target"
    fi
    return 0
}

alias gcrt='get_repo_with_target'

gitreview() {
    if [ -z "$1" ] || [ "$2" ]; then
        echo "Wrong command!"
        echo "Usage: $0 <branch_name>"
        echo
    else
        git push origin HEAD:refs/for/${1}
    fi
}

gprune() {
    if [ -z "$1" ] || [ "$2" ]; then
        primary_branch=main
    else
        primary_branch=$1
    fi
    CurrentBranch=$(git rev-parse --abbrev-ref HEAD)

    # Stash changes
    git stash

    # Checkout primary branch:
    git checkout $primary_branch
    git fetch

    # Run garbage collector
    git gc --prune=now

    # Prune obsolete refs in 3 turns
    git remote prune origin
    git fetch --prune
    git remote prune origin
    git fetch --prune
    git remote prune origin
    git fetch --prune

    # Return to working branch
    git checkout ${CurrentBranch}

    # Unstash work:
    git stash pop
}

# Main
alias g="git"
alias gunsec="git -c http.sslVerify=false"
alias gb="git branch"

# Logs
alias gll='git log --pretty=format:"%h - %an, %ar : %s"'
alias glL='git log --pretty=format:"%H - %an, %ar : %s"'

# Clone
alias gcr="git clone --recurse-submodules"
alias gcb='git clone --single-branch --branch'
alias gcrb='git clone --recurse-submodules --single-branch --branch'

# Look for satus or changes
alias gs="git status"
alias gss="git status"

alias gw="git show"
alias gw^="git show HEAD^"
alias gww="git show HEAD^"
alias gw^^="git show HEAD^^"
alias gwww="git show HEAD^^"
alias gw^^^="git show HEAD^^^"
alias gwwww="git show HEAD^^^"
alias gw^^^^="git show HEAD^^^^"
alias gwwwww="git show HEAD^^^^"
alias gw^^^^^="git show HEAD^^^^^"
alias gwwwwww="git show HEAD^^^^^"
alias gw^^^^^^="git show HEAD^^^^^^"
alias gwwwwwww="git show HEAD^^^^^^"
alias gw^^^^^^^="git show HEAD^^^^^^^"
alias gwwwwwwww="git show HEAD^^^^^^^"
alias gw^^^^^^^^="git show HEAD^^^^^^^^"
alias gwwwwwwwww="git show HEAD^^^^^^^^"

alias ggw="git -c core.pager='delta --features=code-review-chameleon' show"
alias ggw^="git -c core.pager='delta --features=code-review-chameleon' show HEAD^"
alias ggww="git -c core.pager='delta --features=code-review-chameleon' show HEAD^"
alias ggw^^="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^"
alias ggwww="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^"
alias ggw^^^="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^"
alias ggwwww="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^"
alias ggw^^^^="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^"
alias ggwwwww="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^"
alias ggw^^^^^="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^"
alias ggwwwwww="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^"
alias ggw^^^^^^="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^"
alias ggwwwwwww="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^"
alias ggw^^^^^^^="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^^"
alias ggwwwwwwww="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^^"
alias ggw^^^^^^^^="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^^^"
alias ggwwwwwwwww="git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^^^"

alias gd="git diff HEAD"
alias ggd="git -c core.pager='delta --features=code-review-chameleon' diff HEAD"
alias gdo="git diff --cached"

# Add and Commit
# for gco ("git commit only") and gca ("git commit all"), see functions.sh.
# for gget (git clone and cd), see functions.sh.
alias ga="git add"
alias gc="git commit -v"
alias gcn='git commit -m "$(basename $(pwd))"'
alias gcns='git commit -S -m "$(basename $(pwd))"'
alias gcnd='git commit -m "$(basename $(pwd)): $(date +%Y-%m-%d-%H-%M)"'
alias gcnds='git commit -S -m "$(basename $(pwd)): $(date +%Y-%m-%d-%H-%M)"'
alias gcof="git commit --no-verify -m"
alias gcaf="git add --all && gcof"
alias gam="git commit --amend"
alias gamne="git commit --amend --no-edit"
alias gamm="git add --all && git commit --amend -C HEAD"
alias gammf="gamm --no-verify"

# Cleanup
alias gcac="gca Cleanup."
alias gcoc="gco Cleanup."
alias gcaw="gca Whitespace."
alias gcow="gco Whitespace."
alias gfr="git fetch --all && git reset --hard"
alias gfrmn="git fetch --all && git reset --hard origin/main"
alias gfrms="git fetch --all && git reset --hard origin/master"
alias gclean="git reset --hard && git clean -d -x -f"
alias gclean2="git reset --hard && git clean -d -X -f"
alias gclean3="git reset --hard && git clean -d -f"

# Pull
alias gpl='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gpl_gh='git pull github $(git rev-parse --abbrev-ref HEAD)'
alias gplm='git pull && git submodule update'
alias gplmn='git pull origin main'
alias gplmn_gh='git pull github main'
alias gplms='git pull origin master'
alias gplms_gh='git pull github master'
alias gpln='git pull --no-rebase origin $(git rev-parse --abbrev-ref HEAD)'
alias gplp='git pull --rebase && git push'
alias gpls='git stash && git pull && git stash pop'

# Push
alias gpp="git push"
alias gppa="git add . && gcnd && gpp "
alias gppas="git add . && gcnds && gpp "
alias gppg="git push github"
alias gppt="git push --tags"
alias gppu="git push -u"
alias gps='(git stash --include-untracked | grep -v "No local changes to save") && gpp && git stash pop || echo "Fail!"'

# Checkout
alias gck="git checkout"
alias gckb="git checkout -b"
alias gckt="git checkout -"
alias gckmn="git checkout main"
alias gckms="git checkout master"
alias gabr='git branch -r | grep -v "\->" | while read remote; do git branch --track "${remote#origin/}" "$remote"; done'

# Remove Branches
alias gbr="git branch -d"
alias gbrf="git branch -D"
alias gbrr="git push origin --delete"
alias g-to-main="git branch -m master main && git fetch origin && git branch -u origin/main main && git remote set-head origin -a"

# Rebase
alias gcp="git cherry-pick"
alias gfrbd="git fetch origin Development && git rebase origin/Development"
alias gfrbmn="git fetch origin main && git rebase origin/main"
alias gfrbms="git fetch origin master && git rebase origin/master"
alias grb="git rebase -i origin/"
alias grba="git rebase --abort"
alias grbc="git add -A && git rebase --continue"
alias grbd="git rebase -i origin/Development"
alias grbmn="git rebase -i origin/main"
alias grbms="git rebase -i origin/master"
alias gCH="git rebase -i --root"

alias git-rebase-Development='git fetch origin Development && git rebase origin/Development'
alias git-rebase-main='git fetch origin main && git rebase origin/main'
alias git-rebase-master='git fetch origin master && git rebase origin/master'

# Code-Review
alias grw="git review $1"

# Tags
alias grmt='git tag --delete'
alias grmto='git push --delete origin'

# Update
alias gsu='git submodule update --recursive --remote'

# Update all repos in current directory
alias ugr='for dir in `ls`; do echo "${dir}"; cd "${dir}"; git pull origin $(git symbolic-ref --short HEAD); cd ..; done'

# Update all repos within all sub directories from curent
alias ugrs='root=${PWD}; for dir in `ls`; do cd "${root}/${dir}" && ugr; done'

# Misc
alias gex='mono GitExtensions.exe browse'
alias ginfo='ssh gitolite@git info' # Gitolite list repos

git-fetch-all-branches() {
    git branch -r | grep -v '\->' | while read remote; do
        # Remove ANSI escape sequences and whitespace
        remote=$(echo "$remote" | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g' | xargs)
        branchName=$(echo "$remote" | sed 's/^origin\///')

        # Check if local branch already exists
        if ! git branch --list "$branchName" | grep -q "$branchName"; then
            git branch --track "$branchName" "$remote"
        else
            # Set upstream for existing branch if not already set
            if ! git rev-parse --abbrev-ref "$branchName@{upstream}" >/dev/null 2>&1; then
                git branch --set-upstream-to="$remote" "$branchName"
            fi
        fi
    done
    git fetch --all
}

git-fetch-all-branches-recursively() {
    local path="${1:-.}"
    local depth="${2:-0}"
    local current_dir=$(pwd)

    if [ "$depth" -eq 0 ]; then
        # If depth is 0, search all subdirectories
        find "$path" -type d -name ".git" | while read -r git_dir; do
            repo_dir=$(dirname "$git_dir")
            echo "# $repo_dir"
            cd "$repo_dir"
            git-fetch-all-branches
        done
    else
        # If depth is specified, limit the search depth
        find "$path" -maxdepth "$depth" -type d -name ".git" | while read -r git_dir; do
            repo_dir=$(dirname "$git_dir")
            echo "# $repo_dir"
            cd "$repo_dir"
            git-fetch-all-branches
        done
    fi

    cd "$current_dir"
}

git-verbose() {
    if [ -z "${1}" ] || [ ${3} ]; then
        echo "ERROR: Wrong operation...."
        echo "Usage: Git-Verbose <On|Off> [Category]"
        echo "  Categories: curl, trace, pack, packet, perf"
        echo
        return 1
    fi

    if [ -z "${2}" ]; then
        category="all"
    else
        category="${2}"
    fi

    case $1 in
    On | on)
        if [[ "${category}" == "curl" || "${category}" == "all" ]]; then
            export GIT_CURL_VERBOSE=1
            export GIT_TRACE_CURL=1
        fi

        if [[ "${category}" == "trace" || "${category}" == "all" ]]; then
            export GIT_TRACE=1
        fi

        if [[ "${category}" == "pack" || "${category}" == "all" ]]; then
            export GIT_TRACE_PACK_ACCESS=1
        fi

        if [[ "${category}" == "packet" || "${category}" == "all" ]]; then
            export GIT_TRACE_PACKET=1
        fi

        if [[ "${category}" == "perf" || "${category}" == "all" ]]; then
            export GIT_TRACE_PERFORMANCE=1
        fi

        if [[ "${category}" == "setup" || "${category}" == "all" ]]; then
            export GIT_TRACE_SETUP=1
        fi
        ;;
    Off | off)
        export GIT_CURL_VERBOSE=0
        export GIT_TRACE_CURL=0
        export GIT_TRACE=0
        export GIT_TRACE_PACK_ACCESS=0
        export GIT_TRACE_PACKET=0
        export GIT_TRACE_PERFORMANCE=0
        export GIT_TRACE_SETUP=0
        ;;
    *)
        echo "ERROR: Wrong operation...."
        echo "Usage: Git-Verbose <On|Off> [Category]"
        echo "  Categories: curl, trace, pack, packet, perf"
        echo
        ;;
    esac
}

git-commits-by-author() {
    if [ -z "${1}" ] || [ ${3} ]; then
        echo "ERROR: Wrong operation...."
        echo "Usage: git-commits-by-author <Author> [all]"
        echo
        return 1
    fi

    if [ -z ${2} ]; then
        git log --pretty=format:'%Cred%h%Creset %C(bold blue)%an%C(reset) - %s - %Creset %C(yellow)%d%Creset %Cgreen(%cd)%Creset' --abbrev-commit --date=iso --author "${1}"
    else
        git log --pretty=format:'%Cred%h%Creset %C(bold blue)%an%C(reset) - %s - %Creset %C(yellow)%d%Creset %Cgreen(%cd)%Creset' --abbrev-commit --date=iso --all --author "${1}"
    fi
}

git_rename_author() {
    git filter-branch --env-filter "export GIT_COMMITTER_NAME='Dmitry Ivanov';export GIT_COMMITTER_EMAIL='d.k.ivanov@live.com';export GIT_AUTHOR_NAME='Dmitry Ivanov';export GIT_AUTHOR_EMAIL='d.k.ivanov@live.com'" --tag-name-filter cat -- --branches --tags
}

git_push_force() {
    git push --force --tags origin 'refs/heads/*'
}

git_remove_file_from_history() {
    git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $1" --prune-empty --tag-name-filter cat -- --all
}

git_archive_repo() {
    if [ -z "$1" ] || [ $2 ]; then
        echo "You should enter repo URI."
        echo "Usage: git_archive_repo <repo_url>"
        echo
    else
        scheme=$(python3 -c "from urllib.parse import urlparse; uri='${1}'; result = urlparse(uri); print(result.scheme)")
        if [[ ${scheme} = "https" ]]; then
            target=$(python3 -c "from urllib.parse import urlparse; import os.path; uri='${1}'; result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.basename(path[0]))")
        else
            target=$(python3 -c "from urllib.parse import urlparse; import os.path; uri='${1}'; result = urlparse(uri); path = os.path.splitext(result.path.split(':', 1)[-1]); print(os.path.basename(path[0]))")
        fi
        git clone --mirror "${1}" "$target"
        tar --remove-files -cjf "${target}.tar.bz2" "${target}/"
    fi
    return 0
}

git-insertions() {
    if [ -z "${1}" ]; then
        date_from="1970-01-01"
    else
        date_from="${1}"
    fi

    if [ -z "${2}" ]; then
        date_to="$(date +'%Y-%m-%d')"
    else
        date_to="${2}"
    fi
    git log --after="${date_from}" --before="${date_to}" --reverse --stat | grep -Eo "[0-9]{1,} insertions?" | grep -Eo "[0-9]{1,}" | awk "BEGIN { sum=0 } { sum += \$1 } END { print sum }"
}

git-insertions-recurse() {
    if [ -z "${1}" ]; then
        date_from="1970-01-01"
    else
        date_from="${1}"
    fi

    if [ -z "${2}" ]; then
        date_to="$(date +'%Y-%m-%d')"
    else
        date_to="${2}"
    fi
    for dir in $(ls); do
        echo -ne "${dir}: \t"
        cd "${dir}"
        git-insertions ${date_from} ${date_to}
        cd ..
    done
}
