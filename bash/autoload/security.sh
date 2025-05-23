#!/usr/bin/env bash
# Security (SSH, SSL, GPG etc.) scripts.

# sudo (do not forget _ at the end (for alias))
alias sudo="sudo -E "

# ROT13. Encode and decode. JUST FOR Lulz ;)
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"

alias sha='shasum -a 256'
alias genpass='openssl rand -base64'
alias ssl_check_client='openssl s_client -connect'

alias decodecert='openssl x509 -in /dev/stdin -text'

# GPG Aliases
alias gpg_show_keys='gpg --list-secret-keys --keyid-format LONG'

alias ggg='gpg --dry-run -vvvv --import'
alias gpg_show_key_info='gpg --import-options show-only --import --fingerprint'

alias gpg_search_ubuntu='gpg --keyserver keyserver.ubuntu.com --search-key'
alias gpg_search_sks='gpg --keyserver pool.sks-keyservers.net --search-key'
alias gpg_search_mit='gpg --keyserver pgp.mit.edu --search-key'

decryptfrom-base64() {
    echo "${1}" | base64 -d | gpg -d
}

# Straight into console-in-screen.
# Assumes there is only one screen running.
#alias prodc="ssh srv -t screen -RD"

create_rsa_key() {
    # Input:
    if [ -z "$1" ]; then
        echo "Usage: create_rsa_key <key_alias>"
        exit 1
    fi
    ssh-keygen -t rsa -m pem -b 4096 -C "${1}" -f "${1}"
}

convert_openssh_to_rsa() {
    if [ -z "$1" ]; then
        Usage: convert_openssh_to_rsa key_path [old_password] [new_password]
        exit 1
    fi

    ssh-keygen -p -P "${2:=''}" -N "${3:=''}" -m pem -f "$FullPath"
}

convert_pfx_to_crt_and_key() {
    if [ -z "$1" ]; then
        Usage: convert_pfx_to_crt_and_key key_path
        exit 1
    fi
    pfx_full_path=$(realpath ${1})
    pfx_path=$(dirname ${pfx_full_path})
    pfx_file=$(basename ${pfx_full_path})
    pfx_file_name="${pfx_file%.*}"

    echo $pfx_path

    openssl pkcs12 -in "${pfx_full_path}" -nocerts -out "${pfx_path}/${pfx_file_name}.key"
    openssl pkcs12 -in "${pfx_full_path}" -clcerts -nokeys -out "${pfx_path}/${pfx_file_name}.crt"
    openssl rsa -in "${pfx_path}/${pfx_file_name}.key" -out "${pfx_path}/${pfx_file_name}-decrypted.key"
}
