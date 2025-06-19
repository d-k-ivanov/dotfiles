#!/usr/bin/env bash

install-libtorch() {
    declare -a torch_versions=(
        "2.5.0"
        "2.5.1"
        "2.6.0"
        "2.7.1"
    )
    select_from_list "PyTorch version:" selected_torch "${torch_versions[@]}"

    declare -a compute_platforms=(
        "cpu"
        "cu118"
        "cu121"
        "cu124"
        "cu126"
        "cu128"
        "rocm6.1"
        "rocm6.2"
        "rocm6.3"
    )
    select_from_list "Computing platform" selected_platform "${compute_platforms[@]}"

    echo "Installing PyTorch ${selected_torch} for ${selected_platform} to /opt..."
    if [ -d "/opt/libtorch-${selected_torch}+${selected_platform}" ]; then
        print_success "PyTorch ${selected_torch} for ${selected_platform} already installed."
        return
    fi
    sudo wget https://download.pytorch.org/libtorch/${selected_platform}/libtorch-cxx11-abi-shared-with-deps-${selected_torch}%2B${selected_platform}.zip
    sudo unzip libtorch-cxx11-abi-shared-with-deps-${selected_torch}+${selected_platform}.zip
    sudo mv libtorch /opt/libtorch-${selected_torch}+${selected_platform}
    sudo rm libtorch-cxx11-abi-shared-with-deps-${selected_torch}+${selected_platform}.zip
}

set-libtorch() {
    declare -a libtorch_locations=($(ls -dl /opt/libtorch-* | awk '{print $9}'))
    select_from_list "Installed LibTorch:" selected "${libtorch_locations[@]}"
    echo "Using LibTorch: ${selected}..."
    export LIBTORCH="${selected}"
    export LIBTORCH_DIR="${selected}"
    export LD_LIBRARY_PATH_ORIG="${LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH="${selected}/lib:${LD_LIBRARY_PATH}"

    # Save exported variable to the autoload file: ${HOME}/.bash_local/autoload/pytorch.sh (create it if it does not exist)
    if [ ! -d "${HOME}/.bash_local/autoload" ]; then
        mkdir -p "${HOME}/.bash_local/autoload"
    fi
    echo "export LIBTORCH=\"${LIBTORCH}\"" >"${HOME}/.bash_local/autoload/pytorch.sh"
    echo "export LIBTORCH_DIR=\"${LIBTORCH_DIR}\"" >>"${HOME}/.bash_local/autoload/pytorch.sh"
    echo "export LD_LIBRARY_PATH_ORIG=\"${LD_LIBRARY_PATH_ORIG}\"" >>"${HOME}/.bash_local/autoload/pytorch.sh"
    echo "export LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\"" >>"${HOME}/.bash_local/autoload/pytorch.sh"
}

clear-libtorch() {
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
