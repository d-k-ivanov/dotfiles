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
