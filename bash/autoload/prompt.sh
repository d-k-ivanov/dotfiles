#!/usr/bin/env bash

if [[ -n "$VSCODE_INJECTION" ]] || [[ "$TERM_PROGRAM" == "vscode" ]] || [[ -n "$VSCODE_PID" ]]; then
    export IS_IN_VSCODE=1
fi

function unset-prompt-vars {
    unset PromptUserName
    unset PromptCompName
}

function __git_prompt {
    # preserve exit status
    local exit=$?
    local PROMPT
    PROMPT="$(cat ~/.bash/var.prompt)"

    # Colors:
    local K="\033[0;30m"   # black
    local R="\033[0;31m"   # red
    local G="\033[0;32m"   # green
    local Y="\033[0;33m"   # yellow
    local B="\033[0;34m"   # blue
    local M="\033[0;35m"   # magenta
    local C="\033[0;36m"   # cyan
    local W="\033[0;37m"   # white
    local GR="\033[0;090m" # gray
    local BK="\033[1;30m"  # bolded black
    local BR="\033[1;31m"  # bolded red
    local BG="\033[1;32m"  # bolded green
    local BY="\033[1;33m"  # bolded yellow
    local BB="\033[1;34m"  # bolded blue
    local BM="\033[1;35m"  # bolded magenta
    local BC="\033[1;36m"  # bolded cyan
    local BW="\033[1;37m"  # bolded white
    local ZZ="\033[0m"     # Reset

    if [ "${PROMPT}" == "COMPLEX" ]; then
        # Classic Git-Prompt
        # GIT_PS1_SHOWDIRTYSTATE=1
        # GIT_PS1_STATESEPARATOR=""
        # GIT_PS1_SHOWUNTRACKEDFILES=1
        # GIT_PS1_SHOWSTASHSTATE=1
        # GIT_PS1_SHOWCOLORHINTS=1
        # [ $(git config user.pair) ] && GIT_PS1_PAIR="$(git config user.pair)@"
        # __git_ps1 "${BY}[${BC}$GIT_PS1_PAIR%s${BY}]${ZZ}"

        # Git Prompt from Git-Posh
        local gitstring
        gitstring=$(__posh_git_echo)
        echo -en "$gitstring"
    else
        # Classic Git-Prompt
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_STATESEPARATOR=""
        # GIT_PS1_SHOWUNTRACKEDFILES=1
        # GIT_PS1_SHOWSTASHSTATE=1
        # GIT_PS1_SHOWCOLORHINTS=1

        [ "$(git config user.pair)" ] && GIT_PS1_PAIR="$(git config user.pair)@"
        # __git_ps1 "${BY}[${BC}$GIT_PS1_PAIR%s${BY}]${ZZ}"
        __git_ps1 "${BC}$GIT_PS1_PAIR%s${ZZ}" | sed 's/ \([+*%]\{1,\}\)$/\1/'
    fi

    return $exit
}

function __prompt_rvm {
    # preserve exit status
    local exit=$?
    local PROMPT
    PROMPT="$(cat ~/.bash/var.prompt)"
    if [ "$(command -v rvm-prompt)" ]; then
        rbv=$(rvm-prompt)
    fi
    [[ -z ${rbv} ]] && exit
    rbv=${rbv#ruby-}
    [[ $rbv == *"@"* ]] || rbv="${rbv}@default"
    if [ "${PROMPT}" == "COMPLEX" ]; then
        echo "[ Ruby: $rbv ]"
    else
        echo "$rbv"
    fi
    return $exit
}

function __prompt_time {
    # preserve exit status
    local exit=$?
    if [ -n "${timer_output}" ]; then
        printf '%s' "${timer_output}"
    fi
    return $exit
}

bash_prompt() {
    # Colors:
    local K="\[\033[0;30m\]"   # black
    local R="\[\033[0;31m\]"   # red
    local G="\[\033[0;32m\]"   # green
    local Y="\[\033[0;33m\]"   # yellow
    local B="\[\033[0;34m\]"   # blue
    local M="\[\033[0;35m\]"   # magenta
    local C="\[\033[0;36m\]"   # cyan
    local W="\[\033[0;37m\]"   # white
    local GR="\[\033[0;090m\]" # gray
    local BK="\[\033[1;30m\]"  # bolded black
    local BR="\[\033[1;31m\]"  # bolded red
    local BG="\[\033[1;32m\]"  # bolded green
    local BY="\[\033[1;33m\]"  # bolded yellow
    local BB="\[\033[1;34m\]"  # bolded blue
    local BM="\[\033[1;35m\]"  # bolded magenta
    local BC="\[\033[1;36m\]"  # bolded cyan
    local BW="\[\033[1;37m\]"  # bolded white
    local ZZ="\[\033[0m\]"     # Reset

    local username='\u'
    local hostname='\H'

    local ENVRM
    ENVRM="$(cat ~/.bash/var.env)"

    local PROMPT
    PROMPT="$(cat ~/.bash/var.prompt)"

    # Environment:
    if [ -n "$SSH_CLIENT" ]; then
        local SSHIP
        SSHIP=$(echo "$SSH_CLIENT" | awk '{print $1}')
        local SSHPRPT="SSH from $SSHIP"
    else
        local SSHPRPT=""
    fi

    if [[ -v PromptUserName ]] && [[ -v PromptCompName ]]; then
        username="${PromptUserName}"
        hostname="${PromptCompName}"
    fi

    case $PROMPT in
    COMPLEX)
        if [ "$ENVRM" == "PRODUCTION" ]; then
            # PS1="${R}[${BY}\${?}${R}] [\$(__prompt_time)${R}] [${BR}\w${R}] \$(__git_prompt) ${M}\$(__prompt_rvm) ${BR}$SSHPRPT \012${BK}\t \u@\H λ ${ZZ}"
            PS1="${R}[${BY}\${?}${R}] [\$(__prompt_time)${R}] ${BR}\w${R} \$(__git_prompt) ${M}\$(__prompt_rvm) ${BR}$SSHPRPT \012${GR}\t ${username}@${hostname} λ ${ZZ} "
        else
            # PS1="${G}[${BY}\${?}${G}] [\$(__prompt_time)${G}] [${BC}\w${G}] \$(__git_prompt) ${M}\$(__prompt_rvm) ${BB}$SSHPRPT \012{BK}\t \u@\H λ ${ZZ}"
            PS1="${G}[${BY}\${?}${G}] [\$(__prompt_time)${G}] ${BC}\w${G} \$(__git_prompt) ${M}\$(__prompt_rvm) ${BB}$SSHPRPT \012${GR}\t ${username}@${hostname} λ ${ZZ}"
        fi
        ;;
    SIMPLE)
        if [ "$ENVRM" == "PRODUCTION" ]; then
            PS1="${R}[${BY}\${?}${R}] ${username}@${hostname}${BY}:${R}\W \$(__git_prompt) ${M}\$(__prompt_rvm) ${BK}λ ${ZZ}"
        else
            PS1="${G}[${BY}\${?}${G}] ${username}@${hostname}${BY}:${G}\W \$(__git_prompt) ${M}\$(__prompt_rvm) ${BK}λ ${ZZ}"
        fi
        ;;
    esac
}

function devops {
    if command -v starship >/dev/null 2>&1; then
        if [ -f "$HOME/.config/starship/starship.toml" ]; then
            export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
        fi
        eval "$(starship init bash --print-full-init)"
    fi
    export DEVOPSPROMPT=1
}

function undevops {
    # Restore original PROMPT_COMMAND
    if [[ -n "${STARSHIP_PROMPT_COMMAND-}" ]]; then
        PROMPT_COMMAND="$STARSHIP_PROMPT_COMMAND"
        unset STARSHIP_PROMPT_COMMAND
    else
        unset PROMPT_COMMAND
    fi

    # Restore original DEBUG trap
    if [[ -n "${STARSHIP_DEBUG_TRAP-}" ]]; then
        trap "$STARSHIP_DEBUG_TRAP" DEBUG
        unset STARSHIP_DEBUG_TRAP
    else
        trap - DEBUG
    fi

    # Restore original PS0 if using bash 4.4+
    if [[ -n "${BASH_VERSION-}" ]] && [[ "${BASH_VERSINFO[0]}" -gt 4 || ( "${BASH_VERSINFO[0]}" -eq 4 && "${BASH_VERSINFO[1]}" -ge 4 ) ]]; then
        PS0="${PS0#*\}}"
    fi

    # Remove from bash-preexec hooks if present
    if [[ -n "${preexec_functions-}" ]]; then
        preexec_functions=("${preexec_functions[@]/starship_preexec_all}")
    fi
    if [[ -n "${precmd_functions-}" ]]; then
        precmd_functions=("${precmd_functions[@]/starship_precmd}")
    fi

    # Remove ble.sh hooks if present
    if [[ ${BLE_VERSION-} && _ble_version -ge 400 ]]; then
        blehook --remove PREEXEC!='starship_preexec "$_"'
        blehook --remove PRECMD!='starship_precmd'
    fi

    # Unset starship variables
    unset STARSHIP_START_TIME
    unset STARSHIP_END_TIME
    unset STARSHIP_DURATION
    unset STARSHIP_CMD_STATUS
    unset STARSHIP_PIPE_STATUS
    unset STARSHIP_PREEXEC_READY
    unset STARSHIP_SHELL
    unset STARSHIP_SESSION_KEY

    # Restore default PS1 and PS2
    PS1='\s-\v\$ '
    PS2='> '

    # Undefine starship functions
    unset -f starship_preexec
    unset -f starship_precmd
    unset -f starship_preexec_all
    unset -f starship_preexec_ps0
    unset -f _starship_set_return

    unset DEVOPSPROMPT
    preexec_functions+=(timer_start)
    precmd_functions+=(timer_stop)
    bash_prompt
}

if [ $DEVOPSPROMPT ] && [ -z "$IS_IN_VSCODE" ] && command -v starship >/dev/null 2>&1; then
    devops
else
    preexec_functions+=(timer_start)
    precmd_functions+=(timer_stop)
    bash_prompt
fi
