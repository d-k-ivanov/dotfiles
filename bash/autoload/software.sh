#!/usr/bin/env bash

# Mignight commander
# alias mc="mc -a -b"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep 'chrome --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

## Install Various Software Binaries
installKubectl() {
    local versions="1.25.3 1.27.7"
    local version_main="1.27.7"

    echo Installing kubectl binaries...

    for version in $versions; do
        wget "https://storage.googleapis.com/kubernetes-release/release/v${version}/bin/linux/amd64/kubectl" -O ~/.local/bin/kubectl-${version%.*}
        chmod +x ~/.local/bin/kubectl-${version%.*}
    done

    ln -sf ~/.local/bin/kubectl-${version_main%.*} ~/.local/bin/kubectl
    chmod +x ~/.local/bin/kubectl

    echo Finished installing kubectl binaries.
}

installHelm() {
    version="3.9.0"

    echo Installing helm binary...

    TEMP_DIR=$(mktemp -d)
    pushd ${TEMP_DIR}

    wget "https://get.helm.sh/helm-v${version}-linux-amd64.tar.gz" -O "${TEMP_DIR}/helm.tar.gz"
    tar -xzf "helm.tar.gz"
    mv "linux-amd64/helm" ~/.local/bin/helm
    chmod +x ~/.local/bin/helm

    popd
    rm -rf "${TEMP_DIR}"

    echo Finished installing helm binary.
}

installKops() {
    local versions="1.25.2 1.27.2"
    local version_main="1.27.2"

    echo Installing kops binaries...
    for version in $versions; do
        wget "https://github.com/kubernetes/kops/releases/download/v${version}/kops-linux-amd64" -O ~/.local/bin/kops-${version%.*}
        chmod +x ~/.local/bin/kops-${version%.*}
    done

    ln -sf ~/.local/bin/kops-${version_main%.*} ~/.local/bin/kops
    chmod +x ~/.local/bin/kops
    echo Finished installing kops binaries.
}

installAwsCli() {
    echo Installing AWS CLI V2...
    TEMP_DIR=$(mktemp -d)
    wget "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -O ${TEMP_DIR}/awscliv2.zip
    unzip -q "${TEMP_DIR}/awscliv2.zip" -d "${TEMP_DIR}/"
    sudo "${TEMP_DIR}/aws/install" --update
    rm -rf $TEMP_DIR
    echo Finished installing AWS CLI V2.
}

installAwsIamAuthenticator() {
    local version=0.5.10

    echo Installing AWS Iam Authenticator...
    wget "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${version}/aws-iam-authenticator_${version}_linux_amd64" -O ~/.local/bin/aws-iam-authenticator
    chmod +x ~/.local/bin/aws-iam-authenticator
    echo Finished installing AWS Iam Authenticator.
}

installYQ() {
    local version=4.30.4

    echo Installing yq...
    wget "https://github.com/mikefarah/yq/releases/download/v${version}/yq_linux_amd64" -O ~/.local/bin/yq
    chmod +x ~/.local/bin/yq
    echo Finished installing yq.
}

installAll() {
    installKubectl
    installHelm
    installKops
    installAwsCli
    installAwsIamAuthenticator
    installYQ
}
