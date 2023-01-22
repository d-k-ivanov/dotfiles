#!/usr/bin/env bash

script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
script_name="$(basename ${0%.*})"
script_py="${script_path}/${script_name}.py"
python $script_py
