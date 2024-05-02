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
