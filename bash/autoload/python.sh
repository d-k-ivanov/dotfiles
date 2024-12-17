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
alias vinsr='[[ -f requirements.txt ]] && python -m pip install -r requirements.txt || echo -n'
alias vinsd='[[ -f requirements-dev.txt ]] && python -m pip install -r requirements-dev.txt || echo -n'
alias vinsm='[[ -f requirements-misc.txt ]] && python -m pip install -r requirements-misc.txt || echo -n'
alias vins='vpip && vinsr && vinsd && vinsm'

# Basic environment
alias pip-update='python -m pip install --upgrade pip'
alias ipython-install='python -m pip install ipython'

alias srv='python -m http.server 8000'

py_venv() {
    python -m pip install --upgrade pip
    python -m pip install --upgrade virtualenv
    python -m pip install --upgrade ipython
}
alias pip_update='py_venv'

pyclean() {
    temp_file=$(mktemp)
    python -m pip freeze >"${temp_file}"
    python -m pip uninstall -y -r "${temp_file}"
    rm -f "${temp_file}"
}

if [[ -f "$PYENV_ROOT/bin/pyenv" ]]; then
    command pyenv rehash 2>/dev/null
    pyenv() {
        local command
        command="${1:-}"
        if [ "$#" -gt 0 ]; then
            shift
        fi

        case "$command" in
        rehash | shell)
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

if [[ -f "${HOME}/miniconda3/bin/conda" ]]; then
    __conda_setup="$(${HOME}/miniconda3/bin/conda 'shell.bash' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "${HOME}/miniconda3/etc/profile.d/conda.sh" ]; then
            . "${HOME}/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="${HOME}/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi
