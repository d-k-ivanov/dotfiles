#!/usr/bin/env bash

install-libtorch() {
    declare -a torch_versions=(
        "2.5.1"
    )

    declare -a compute_platforms=(
        "cpu"
        "cu118"
        "cu121"
        "cu124"
    )

}
