#!/usr/bin/env bash

export VCPKG_DISABLE_METRICS=1
# export VCPKG_FEATURE_FLAGS="versions"

alias    vcpkg-remove='vcpkg remove            --triplet x64-linux'
alias   vcpkg-install='vcpkg install           --triplet x64-linux'
alias  vcpkg-remove-r='vcpkg remove  --recurse --triplet x64-linux'
alias vcpkg-install-r='vcpkg install --recurse --triplet x64-linux'

alias    vcpkg-remove-osx='vcpkg remove            --triplet x64-osx'
alias   vcpkg-install-osx='vcpkg install           --triplet x64-osx'
alias  vcpkg-remove-osx-r='vcpkg remove  --recurse --triplet x64-osx'
alias vcpkg-install-osx-r='vcpkg install --recurse --triplet x64-osx'

vcpkg-possible-paths() {
    local -a paths=(
        "$HOME/.vcpkg"
        "$WORKSPACE/vcpkg"
        "/opt/vcpkg"
    )

    local -a existing_paths=()
    for path in "${paths[@]}"; do
        if [[ -x "${path}/vcpkg" ]]; then
            existing_paths+=("$path")
        fi
    done

    printf '%s\n' "${existing_paths[@]}"
}

vcpkg-set() {
    if [ ! -d "${HOME}/.bash_local/autoload" ]; then
        mkdir -p "${HOME}/.bash_local/autoload"
    fi

    local vcpkg_paths
    readarray -t vcpkg_paths < <(vcpkg-possible-paths)

    select_from_list "VCPKG Path:" selected "${vcpkg_paths[@]}"
    echo "Using VCPKG: ${selected}..."

    echo "export VCPKG_ROOT=\"${selected}\"" >"${HOME}/.bash_local/autoload/vcpkg.sh"
    export VCPKG_ROOT="${selected}"
    export PATH="${VCPKG_ROOT}:${PATH}"

}

vcpkg-unset() {
    if [ -f "${HOME}/.bash_local/autoload/vcpkg.sh" ]; then
        rm "${HOME}/.bash_local/autoload/vcpkg.sh"
    fi

    if [[ -n "$VCPKG_ROOT" ]]; then
        export PATH=$(echo $PATH | tr ":" "\n" | grep -v "$VCPKG_ROOT" | tr "\n" ":")
        unset VCPKG_ROOT
    fi
}

vcpkg-enable() {
    local -a vcpkg_paths
    readarray -t vcpkg_paths < <(vcpkg-possible-paths)

    select_from_list "VCPKG Path:" selected "${vcpkg_paths[@]}"
    echo "Using VCPKG: ${selected}..."

    export VCPKG_ROOT="${selected}"
    export PATH="${VCPKG_ROOT}:${PATH}"
}

vcpkg-disable() {
    if [[ -z "$VCPKG_ROOT" ]]; then
        print_error "VCPKG_ROOT is not set, cannot disable VCPKG"
        return 1
    fi

    if [[ -n "$VCPKG_ROOT" ]]; then
        export PATH=$(echo $PATH | tr ":" "\n" | grep -v "$VCPKG_ROOT" | tr "\n" ":")
        unset VCPKG_ROOT
    fi
}

vcpkg-cmake()
{
    vcpkgPath=$(dirname $(which vcpkg))
    echo -n "-DCMAKE_TOOLCHAIN_FILE=${vcpkgPath}/scripts/buildsystems/vcpkg.cmake"
}

vcpkg-batch-install()
{
    build_triplet='x64-linux'
    if [[ $(uname -s) == 'Darwin' ]]; then
        build_triplet='x64-osx'
    fi

    vcpkg install --keep-going --recurse --triplet ${build_triplet} \
        "3dxware" \
        "assimp" \
        "boost" \
        "catch2" \
        "cgal" \
        "dirent" \
        "draco" \
        "eigen3" \
        "embree3" \
        "fakeit" \
        "fmt" \
        "freeglut" \
        "glad" \
        "glew" \
        "glfw3" \
        "glib" \
        "glm" \
        "gts" \
        "imgui[docking-experimental,glfw-binding,opengl3-binding,vulkan-binding]" \
        "imguizmo" \
        "libjpeg-turbo" \
        "lodepng" \
        "ode" \
        "opencv4[contrib]" \
        "openssl" \
        "pugixml" \
        "qt3d" \
        "qtbase" \
        "qtsvg" \
        "qttools" \
        "qt5-3d" \
        "qt5-base" \
        "qt5-tools" \
        "quazip" \
        "quazip5" \
        "spdlog" \
        "stb" \
        "vtk" \
        "vulkan" \
        "yaml-cpp"
}
