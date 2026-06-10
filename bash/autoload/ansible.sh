#!/usr/bin/env bash

alias ap="ansible-playbook "

function ansible_show_secret_var() {
    local variable_name="$1"
    local file_path="$2"
    ansible localhost -m ansible.builtin.debug -a "var=${variable_name}" -e "@${file_path}" --ask-vault-pass
}

function ansible_show_secret_var_with_file() {
    local variable_name="$1"
    local file_path="$2"
    local vault_pass_file_path="$3"
    ansible localhost -m ansible.builtin.debug -a "var=${variable_name}" -e "@${file_path}" --vault-password-file="${vault_pass_file_path}"
}
