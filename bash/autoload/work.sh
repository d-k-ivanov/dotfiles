#!/usr/bin/env bash

alias wget-cc="wget --user '${CC_NEXUS_USER}' --password '${CC_NEXUS_PASSWORD}' "
alias curl-cc="curl -L -u '${CC_NEXUS_USER}:${CC_NEXUS_PASSWORD}' "

export CC_VCPKG_DEV=${HOME}/v
export CC_VCPKG_ROOT=${HOME}/vcpkg

# === Current === #
alias   ccdev="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/dev                                      ${CC_VCPKG_DEV}"
alias  ccdevm="rm -f ${CC_VCPKG_DEV}; ln -sf ${WORKSPACE}/.vcpkg                                       ${CC_VCPKG_DEV}"
alias  ccdevs="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/shit                                     ${CC_VCPKG_DEV}"
alias  ccdev5="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${CC_VCPKG_DEV}"
alias ccdev60="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/fea1b6ae25a41b52e4581ff690c178d4a9224740 ${CC_VCPKG_DEV}"
alias ccdev61="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${CC_VCPKG_DEV}"
alias ccdev70="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/9c921f33c                                ${CC_VCPKG_DEV}"
alias ccdev71="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a101126ba                                ${CC_VCPKG_DEV}"
alias ccdev72="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/286666521                                ${CC_VCPKG_DEV}"
alias ccdev73="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/617fb6a9d                                ${CC_VCPKG_DEV}"
alias ccdev74="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/6ef94459d                                ${CC_VCPKG_DEV}"
alias ccdev80="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/3f605a228                                ${CC_VCPKG_DEV}"
alias ccdev81="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/dcc8b01f3                                ${CC_VCPKG_DEV}"


# === Legacy  === #
alias ccdev24="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/db5bd8485aea62500c09491a959a0fe7cc254e85 ${HOME}/vcpkg-export-latest"
alias ccdev25="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/db5bd8485aea62500c09491a959a0fe7cc254e85 ${HOME}/vcpkg-export-latest"
alias ccdev26="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/8eaa6567bc1462280ce5200dc06391e847b5fd83 ${HOME}/vcpkg-export-latest"
alias ccdev3=" rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${HOME}/vcpkg-export-latest"
alias ccdev4=" rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${HOME}/vcpkg-export-latest"
alias ccdev5l="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/a761262edcfa6bb92eab2917ac9c4382138b3bf5 ${HOME}/vcpkg-export-latest"
alias ccdev6l="rm -f ${CC_VCPKG_DEV}; ln -sf ${CC_VCPKG_ROOT}/fea1b6ae25a41b52e4581ff690c178d4a9224740 ${HOME}/vcpkg-export-latest"
