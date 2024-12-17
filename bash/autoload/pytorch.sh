#!/usr/bin/env bash

install_libtorch() {
    declare -a torch_versions=(
        "2.5.1"
    )
    select_from_list "PyTorch version:" selected_torch "${torch_versions[@]}"

    declare -a compute_platforms=(
        "cpu"
        "cu118"
        "cu121"
        "cu124"
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
