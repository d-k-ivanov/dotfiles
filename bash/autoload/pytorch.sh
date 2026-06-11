#!/usr/bin/env bash

# Package lists:
# https://download.pytorch.org/libtorch/cpu/
# https://download.pytorch.org/libtorch/cu118/
# https://download.pytorch.org/libtorch/cu121/
# https://download.pytorch.org/libtorch/cu124/
# https://download.pytorch.org/libtorch/cu126/
# https://download.pytorch.org/libtorch/cu128/
# https://download.pytorch.org/libtorch/cu130/
# https://download.pytorch.org/libtorch/cu132/
# https://download.pytorch.org/libtorch/rocm6.1/
# https://download.pytorch.org/libtorch/rocm6.2/
# https://download.pytorch.org/libtorch/rocm6.3/
install-libtorch() {
    declare -a torch_versions=(
        "2.4.0"
        "2.4.1"
        "2.5.0"
        "2.5.1"
        "2.6.0"
        "2.7.1"
        "2.8.0"
        "2.9.0"
        "2.9.1"
        "2.10.0"
        "2.11.0"
        "2.12.0"
    )
    select_from_list "PyTorch version:" selected_torch "${torch_versions[@]}"

    # Supported platforms by version:
    # cpu: 2.4.0, 2.4.1, 2.5.0, 2.5.1, 2.6.0, 2.7.1, 2.8.0, 2.9.0, 2.9.1, 2.10.0, 2.11.0, 2.12.0
    # cu118: 2.4.0, 2.4.1, 2.5.0, 2.5.1, 2.6.0, 2.7.1
    # cu121: 2.4.0, 2.4.1, 2.5.0, 2.5.1
    # cu124: 2.4.0, 2.4.1, 2.5.0, 2.5.1, 2.6.0
    # cu126: 2.6.0, 2.7.1, 2.8.0, 2.9.0, 2.9.1, 2.10.0, 2.11.0, 2.12.0
    # cu128: 2.7.1, 2.8.0, 2.9.0, 2.9.1, 2.10.0, 2.11.0, 2.12.0
    # cu130: 2.9.0, 2.9.1, 2.10.0, 2.11.0, 2.12.0
    # cu132: 2.12.0
    # rocm6.1: 2.4.0, 2.4.1, 2.5.0, 2.5.1, 2.6.0
    # rocm6.2: 2.5.0, 2.5.1
    # rocm6.3: 2.7.1, 2.8.0, 2.9.0, 2.9.1
    # rocm6.4: 2.8.0, 2.9.0, 2.9.1
    declare -a compute_platforms=("cpu")
    case "${selected_torch}" in
    "2.4.0" | "2.4.1")
        compute_platforms+=("cu118" "cu121" "cu124" "rocm6.1")
        ;;
    "2.5.0" | "2.5.1")
        compute_platforms+=("cu118" "cu121" "cu124" "rocm6.1" "rocm6.2")
        ;;
    "2.6.0")
        compute_platforms+=("cu118" "cu124" "cu126" "rocm6.1")
        ;;
    "2.7.1")
        compute_platforms+=("cu118" "cu126" "cu128" "rocm6.3")
        ;;
    "2.8.0")
        compute_platforms+=("cu126" "cu128" "rocm6.3" "rocm6.4")
        ;;
    "2.9.0" | "2.9.1")
        compute_platforms+=("cu126" "cu128" "cu130" "rocm6.3" "rocm6.4")
        ;;
    "2.10.0" | "2.11.0")
        compute_platforms+=("cu126" "cu128" "cu130")
        ;;
    "2.12.0")
        compute_platforms+=("cu126" "cu128" "cu130" "cu132")
        ;;
    esac
    select_from_list "Computing platform" selected_platform "${compute_platforms[@]}"

    echo "Installing PyTorch ${selected_torch} for ${selected_platform} to /opt..."
    if [ -d "/opt/libtorch-${selected_torch}+${selected_platform}" ]; then
        print_success "PyTorch ${selected_torch} for ${selected_platform} already installed."
        return
    fi

    # printf '%s\n%s\n' ${selected_torch} "2.7.1" | sort -CV
    # `sort -CV` checks if the input is sorted. If the input is sorted, it returns 0, otherwise it returns 1.
    # This way we simulate the version comparison:
    #   "2.5.1" "2.7.1" are sorted at the input state, so it's true.
    #   "2.9.1" "2.7.1" are not sorted at the input state, so it's false.
    if printf '%s\n%s\n' "${selected_torch}" "2.7.1" | sort -CV; then
        sudo wget https://download.pytorch.org/libtorch/${selected_platform}/libtorch-cxx11-abi-shared-with-deps-${selected_torch}%2B${selected_platform}.zip
        sudo unzip libtorch-cxx11-abi-shared-with-deps-${selected_torch}+${selected_platform}.zip
        sudo mv libtorch /opt/libtorch-${selected_torch}+${selected_platform}
        sudo rm libtorch-cxx11-abi-shared-with-deps-${selected_torch}+${selected_platform}.zip
    else
        sudo wget https://download.pytorch.org/libtorch/${selected_platform}/libtorch-shared-with-deps-${selected_torch}%2B${selected_platform}.zip
        sudo unzip libtorch-shared-with-deps-${selected_torch}+${selected_platform}.zip
        sudo mv libtorch /opt/libtorch-${selected_torch}+${selected_platform}
        sudo rm libtorch-shared-with-deps-${selected_torch}+${selected_platform}.zip
    fi
}

set-libtorch() {
    local save=0
    local help=0
    # Parse options
    # --save|-s   Save the selected LibTorch version to the autoload file
    # --help|-h   Show help message
    local options=$(getopt -l "help,save" -o "hs" -a -- "$@")
    if [ $? -ne 0 ]; then
        echo "Invalid options provided. Use -h or --help for usage information."
        return 1
    fi
    eval set -- "${options}"
    while true; do
        case "$1" in
        -s | --save)
            save=1
            shift
            ;;
        -h | --help)
            help=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Invalid option: $1"
            return 1
            ;;
        esac
    done

    if [ ${help} -eq 1 ]; then
        echo "Usage: set-libtorch [-s] [-h]"
        echo "  -s, --save   Save the selected LibTorch version to the autoload file"
        echo "  -h, --help   Show this help message"
        return 0
    fi

    declare -a libtorch_locations=($(ls -dl /opt/libtorch-* | awk '{print $9}'))
    select_from_list "Installed LibTorch:" selected "${libtorch_locations[@]}"
    echo "Using LibTorch: ${selected}..."
    export LIBTORCH="${selected}"
    export LIBTORCH_DIR="${selected}"
    export LD_LIBRARY_PATH_ORIG="${LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH="${selected}/lib:${LD_LIBRARY_PATH}"

    if [ ${save} -eq 1 ]; then
        # Save exported variable to the autoload file: ${HOME}/.bash_local/autoload/pytorch.sh (create it if it does not exist)
        if [ ! -d "${HOME}/.bash_local/autoload" ]; then
            mkdir -p "${HOME}/.bash_local/autoload"
        fi
        echo "export LIBTORCH=\"${LIBTORCH}\"" >"${HOME}/.bash_local/autoload/pytorch.sh"
        echo "export LIBTORCH_DIR=\"${LIBTORCH_DIR}\"" >>"${HOME}/.bash_local/autoload/pytorch.sh"
        echo "export LD_LIBRARY_PATH_ORIG=\"${LD_LIBRARY_PATH_ORIG}\"" >>"${HOME}/.bash_local/autoload/pytorch.sh"
        echo "export LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\"" >>"${HOME}/.bash_local/autoload/pytorch.sh"
    fi
}

unset-libtorch() {
    unset LIBTORCH
    unset LIBTORCH_DIR
    if [ -n "${LD_LIBRARY_PATH_ORIG}" ]; then
        export LD_LIBRARY_PATH="${LD_LIBRARY_PATH_ORIG}"
    else
        unset LD_LIBRARY_PATH
    fi

    # Remove the autoload file: ${HOME}/.bash_local/autoload/pytorch.sh
    if [ -f "${HOME}/.bash_local/autoload/pytorch.sh" ]; then
        rm "${HOME}/.bash_local/autoload/pytorch.sh"
    fi
}
