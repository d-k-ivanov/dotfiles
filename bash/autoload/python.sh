#!/usr/bin/env bash

alias vc='python -m venv venv'
alias vc3='python3 -m venv venv'
alias vc2='python2 -m virtualenv -p $(which python2) venv'
alias va='source ./venv/bin/activate'
alias vd='deactivate'
alias vr='rm -rf ./venv'
alias vpi='python -m pip install'
alias vpip='python -m pip install --upgrade pip'
alias vgen='python -m pip freeze > requirements.txt'
alias vins='vpip && vinsr && vinsd'
alias vinsr='python -m pip install -r requirements.txt'
alias vinsd='python -m pip install -r requirements-dev.txt'

# Basic environment
alias pip-update='python -m pip install --upgrade pip'
alias ipython-install='python -m pip install ipython'

alias srv='python -m http.server 8000'

py_venv()
{
    python -m pip install --upgrade pip
    python -m pip install --upgrade virtualenv
    python -m pip install --upgrade ipython
}
alias pip_update='py_venv'

if [[ -f "$PYENV_ROOT/bin/pyenv" ]]; then
    command pyenv rehash 2>/dev/null
    pyenv()
    {
        local command
        command="${1:-}"
        if [ "$#" -gt 0 ]; then
          shift
        fi

        case "$command" in
        rehash|shell)
            eval "$(pyenv "sh-$command" "$@")"
            ;;
        *)
            command pyenv "$command" "$@"
            ;;
        esac
    }
fi

# command -v pyenv >/dev/null && eval "$(pyenv init -)"
# command -v pyenv >/dev/null && eval "$(pyenv virtualenv-init -)"
