#!/usr/bin/env bash

export CC_VCPKG_DEV=${HOME}/v
export CC_VCPKG_ROOT=${HOME}/vcpkg

# === Current === #
alias   ccdev="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/dev                                      ${CC_VCPKG_DEV}"
alias  ccdevm="rm ${CC_VCPKG_DEV}; ln -sf ${WORKSPACE}/vcpkg                                        ${CC_VCPKG_DEV}"
alias  ccdevs="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/shit                                     ${CC_VCPKG_DEV}"
alias  ccdev5="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${CC_VCPKG_DEV}"
alias ccdev60="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/fea1b6ae25a41b52e4581ff690c178d4a9224740 ${CC_VCPKG_DEV}"
alias ccdev61="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${CC_VCPKG_DEV}"
alias ccdev70="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/9c921f33c                                ${CC_VCPKG_DEV}"
alias ccdev71="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a101126ba                                ${CC_VCPKG_DEV}"

# === Legacy  === #
alias ccdev24="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/db5bd8485aea62500c09491a959a0fe7cc254e85 ${HOME}/vcpkg-export-latest"
alias ccdev25="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/db5bd8485aea62500c09491a959a0fe7cc254e85 ${HOME}/vcpkg-export-latest"
alias ccdev26="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/8eaa6567bc1462280ce5200dc06391e847b5fd83 ${HOME}/vcpkg-export-latest"
alias ccdev3=" rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${HOME}/vcpkg-export-latest"
alias ccdev4=" rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${HOME}/vcpkg-export-latest"
alias ccdev5l="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${HOME}/vcpkg-export-latest"
alias ccdev6l="rm ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/fea1b6ae25a41b52e4581ff690c178d4a9224740 ${HOME}/vcpkg-export-latest"
