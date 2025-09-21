#!/usr/bin/env bash

alias vc='python -m venv venv'
alias vc2='python2 -m virtualenv -p $(which python2) venv'
alias vc3='python3 -m venv venv'
alias va='source ./venv/bin/activate'
alias vr='rm -rf ./venv'

alias vcd='python -m venv .venv'
alias vc2d='python2 -m virtualenv -p $(which python2) .venv'
alias vc3d='python3 -m venv .venv'
alias vad='source ./.venv/bin/activate'
alias vrd='rm -rf ./.venv'

alias vd='deactivate'
alias vpi='python -m pip install'
alias vpip='python -m pip install --upgrade pip'
alias vgen='python -m pip freeze > requirements.txt'
alias vinsr='[[ -f requirements.txt ]] && python -m pip install -r requirements.txt || echo -n'
alias vinsd='[[ -f requirements-dev.txt ]] && python -m pip install -r requirements-dev.txt || echo -n'
alias vinsm='[[ -f requirements-misc.txt ]] && python -m pip install -r requirements-misc.txt || echo -n'

# alias vins='vpip && vinsr && vinsd && vinsm'
vins() {
    if [[ -f ${1} ]]; then
        vpip
        python -m pip install -r ${1}
    else
        vpip
        vinsr
        vinsd
        vinsm
    fi
}

# Basic environment
alias pip-update='python -m pip install --upgrade pip'
alias ipython-install='python -m pip install ipython'

alias srv='python -m http.server 8000'

py_venv() {
    python -m pip install --upgrade pip
}
alias pip_update='py_venv'

pyclean() {
    temp_file=$(mktemp)
    python -m pip freeze >"${temp_file}"
    python -m pip uninstall -y -r "${temp_file}"
    rm -f "${temp_file}"
}

pyenv-set() {
    if [ ! -d "${HOME}/.bash_local/autoload" ]; then
        mkdir -p "${HOME}/.bash_local/autoload"
    fi
    echo "export PATH=\"${PYENV_ROOT}/bin:\$PATH\"" >>"${HOME}/.bash_local/autoload/pyenv.sh"
    echo "export PATH=\"${PYENV_ROOT}/shims:\$PATH\"" >>"${HOME}/.bash_local/autoload/pyenv.sh"
}

pyenv-unset() {
    if [ -f "${HOME}/.bash_local/autoload/pyenv.sh" ]; then
        rm "${HOME}/.bash_local/autoload/pyenv.sh"
    fi
    export PATH=$(echo $PATH | tr ":" "\n" | grep -v "$PYENV_ROOT/bin" | tr "\n" ":")
    export PATH=$(echo $PATH | tr ":" "\n" | grep -v "$PYENV_ROOT/shims" | tr "\n" ":")
}

pyenv-enable() {
    [[ -d $PYENV_ROOT/shims ]] && export PATH="$PYENV_ROOT/shims:$PATH"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
}

pyenv-disable() {
    export PATH=$(echo $PATH | tr ":" "\n" | grep -v "$PYENV_ROOT/shims" | tr "\n" ":")
    export PATH=$(echo $PATH | tr ":" "\n" | grep -v "$PYENV_ROOT/bin" | tr "\n" ":")
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

if [[ -f "${HOME}/miniforge3/bin/conda" ]]; then
    __conda_setup="$(${HOME}/miniforge3/bin/conda 'shell.bash' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "${HOME}/miniforge3/etc/profile.d/conda.sh" ]; then
            . "${HOME}/miniforge3/etc/profile.d/conda.sh"
        else
            export PATH="${HOME}/miniforge3/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi
