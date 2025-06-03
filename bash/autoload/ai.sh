#!/usr/bin/env bash

# Check if sourced
(return 0 2>/dev/null) || {
    echo "Error: This script must be sourced (e.g., '. ai.sh'). Exiting..." >&2
    return 1 2>/dev/null || exit 1
}

ai_venv_path="$HOME/.local/ai_venv"

aivenv_activate() {
    if [ -f "${ai_venv_path}/bin/activate" ]; then
        echo -e "\033[1;33mActivating AI virtual environment at ${ai_venv_path}...\033[0m"
        # shellcheck disable=SC1090
        source "${ai_venv_path}/bin/activate"
    else
        echo -e "\033[1;31mAI virtual environment not found at ${ai_venv_path}. Initializing...\033[0m"
        aivenv_init
    fi
}
alias ai=aivenv_activate

aivenv_deactivate() {
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
    fi
}
alias aid=aivenv_deactivate

aivenv_rm() {
    aivenv_deactivate
    if [ -d "${ai_venv_path}" ]; then
        rm -rf "${ai_venv_path}"
    fi
}
alias air=aivenv_rm

aivenv_init() {
    if [ -f "${ai_venv_path}/bin/activate" ]; then
        aivenv_activate
        return
    fi

    python3 -m venv "${ai_venv_path}"
    # shellcheck disable=SC1090
    source "${ai_venv_path}/bin/activate"

    python -m pip install --upgrade pip
    python -m pip install --upgrade anthropic
    python -m pip install --upgrade black
    python -m pip install --upgrade google-genai
    python -m pip install --upgrade httpx==0.27.2
    python -m pip install --upgrade ollama
    python -m pip install --upgrade openai
    python -m pip install --upgrade pyperclip
}
alias aii=aivenv_init

aivenv_update() {
    if [ -d "${ai_venv_path}" ]; then
        aivenv_activate
        tmpfile=$(mktemp)
        python -m pip freeze --all | cut -d= -f1 >"$tmpfile"
        python -m pip install --upgrade -r "$tmpfile"
        rm -f "$tmpfile"
    else
        aivenv_init
    fi
}
alias aiu=aivenv_update
