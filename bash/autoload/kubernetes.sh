#!/usr/bin/env bash

# Local Environment
# ==================================================================================================
alias          kdocker='kubectl --context      docker-desktop'
alias          hdocker='helm    --kube-context docker-desktop'
alias    kdocker_proxy='kdocker proxy --port=10001'
alias kdocker_port_fwd='kdocker port-forward --v=6 --address 0.0.0.0 service/'
alias   kdocker_consul='kdocker port-forward service/consul 8300 8301 8302 8500 8600'
alias   kdocker_rabbit='kdocker port-forward service/rabbitmq-ha 4369 5672 15672 15692'

function kdocker_exec()
{
    kdocker exec -it $@ -- sh -c '(bash || ash || sh)'
}

# Dev Environment
# ==================================================================================================
# alias     kdev='kubectl --context dev'
# alias   kdevcn='kubectl --context devcn'
# alias   kdeveu='kubectl --context deveu'
# alias   kdevus='kubectl --context devus'

# alias     hdev='helm --kube-context dev'
# alias   hdevcn='helm --kube-context devcn'
# alias   hdeveu='helm --kube-context deveu'
# alias   hdevus='helm --kube-context devus'

alias     kdev_proxy='kdev   proxy --port=10001'
alias   kdevcn_proxy='kdevcn proxy --port=10001'
alias   kdeveu_proxy='kdeveu proxy --port=10001'
alias   kdevus_proxy='kdevus proxy --port=10001'

alias     kdev_port_fwd='kdev   port-forward --v=6 --address 0.0.0.0 service/'
alias   kdevcn_port_fwd='kdevcn port-forward --v=6 --address 0.0.0.0 service/'
alias   kdeveu_port_fwd='kdeveu port-forward --v=6 --address 0.0.0.0 service/'
alias   kdevus_port_fwd='kdevus port-forward --v=6 --address 0.0.0.0 service/'

alias     kdev_consul='kdev   port-forward service/consul 8300 8301 8302 8500 8600'
alias   kdevcn_consul='kdevcn port-forward service/consul 8300 8301 8302 8500 8600'
alias   kdeveu_consul='kdeveu port-forward service/consul 8300 8301 8302 8500 8600'
alias   kdevus_consul='kdevus port-forward service/consul 8300 8301 8302 8500 8600'

alias     kdev_rabbit='kdev   port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias   kdevcn_rabbit='kdevcn port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias   kdeveu_rabbit='kdeveu port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias   kdevus_rabbit='kdevus port-forward service/rabbitmq-ha 4369 5672 15672 15692'

function kdev_exec()
{
    kdev exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kdevcn_exec()
{
    kdevcn exec -it $@ -- sh -c '(bash || ash || sh)'
}

# DevOps Environment
# ==================================================================================================
# alias   kdevops='kubectl --context devops'
# alias kdevopscn='kubectl --context devopscn'
# alias kdevopseu='kubectl --context devopseu'
# alias kdevopsus='kubectl --context devopsus'

# alias   hdevops='helm --kube-context devops'
# alias hdevopscn='helm --kube-context devopscn'
# alias hdevopseu='helm --kube-context devopseu'
# alias hdevopsus='helm --kube-context devopsus'

alias   kdevops_proxy='kdevops   proxy --port=10001'
alias kdevopscn_proxy='kdevopscn proxy --port=10001'
alias kdevopseu_proxy='kdevopseu proxy --port=10001'
alias kdevopsus_proxy='kdevopsus proxy --port=10001'

alias   kdevops_port_fwd='kdevops   port-forward --v=6 --address 0.0.0.0 service/'
alias kdevopscn_port_fwd='kdevopscn port-forward --v=6 --address 0.0.0.0 service/'
alias kdevopseu_port_fwd='kdevopseu port-forward --v=6 --address 0.0.0.0 service/'
alias kdevopsus_port_fwd='kdevopsus port-forward --v=6 --address 0.0.0.0 service/'

alias   kdevops_consul='kdevops   port-forward service/consul 8300 8301 8302 8500 8600'
alias kdevopscn_consul='kdevopscn port-forward service/consul 8300 8301 8302 8500 8600'
alias kdevopseu_consul='kdevopseu port-forward service/consul 8300 8301 8302 8500 8600'
alias kdevopsus_consul='kdevopsus port-forward service/consul 8300 8301 8302 8500 8600'

alias   kdevops_rabbit='kdevops    port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kdevopscn_rabbit='kdevopscn  port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kdevopseu_rabbit='kdevopseu  port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kdevopsus_rabbit='kdevopsus  port-forward service/rabbitmq-ha 4369 5672 15672 15692'

function kdevops_exec()
{
    kdevops exec -it $@ -- sh -c '(bash || ash || sh)'
}

# Stage Environment
# ==================================================================================================
# alias   kstage='kubectl --context stage'
# alias kstagecn='kubectl --context stagecn'
# alias kstageeu='kubectl --context stageeu'
# alias kstageus='kubectl --context stageus'

# alias   hstage='helm --kube-context stage'
# alias hstagecn='helm --kube-context stagecn'
# alias hstageeu='helm --kube-context stageeu'
# alias hstageus='helm --kube-context stageus'

alias   kstage_proxy='kstage   proxy --port=10001'
alias kstagecn_proxy='kstagecn proxy --port=10001'
alias kstageeu_proxy='kstageeu proxy --port=10001'
alias kstageus_proxy='kstageus proxy --port=10001'

alias   kstage_port_fwd='kstage   port-forward --v=6 --address 0.0.0.0 service/'
alias kstagecn_port_fwd='kstagecn port-forward --v=6 --address 0.0.0.0 service/'
alias kstageeu_port_fwd='kstageeu port-forward --v=6 --address 0.0.0.0 service/'
alias kstageus_port_fwd='kstageus port-forward --v=6 --address 0.0.0.0 service/'

alias   kstage_consul='kstage   port-forward service/consul 8300 8301 8302 8500 8600'
alias kstagecn_consul='kstagecn port-forward service/consul 8300 8301 8302 8500 8600'
alias kstageeu_consul='kstageeu port-forward service/consul 8300 8301 8302 8500 8600'
alias kstageus_consul='kstageus port-forward service/consul 8300 8301 8302 8500 8600'

alias   kstage_rabbit='kstage   port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kstagecn_rabbit='kstagecn port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kstageeu_rabbit='kstageeu port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kstageus_rabbit='kstageus port-forward service/rabbitmq-ha 4369 5672 15672 15692'

function kstage_exec()
{
    kstage exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kstagecn_exec()
{
    kstagecn exec -it $@ -- sh -c '(bash || ash || sh)'
}

# Prod Environment
# ==================================================================================================
# alias   kprod='kubectl --context prod'
# alias kprodcn='kubectl --context prodcn'
# alias kprodeu='kubectl --context prodeu'
# alias kprodus='kubectl --context produs'

# alias   hprod='helm --kube-context prod'
# alias hprodcn='helm --kube-context prodcn'
# alias hprodeu='helm --kube-context prodeu'
# alias hprodus='helm --kube-context produs'

alias   kprod_proxy='kprod   proxy --port=10001'
alias kprodcn_proxy='kprodcn proxy --port=10001'
alias kprodeu_proxy='kprodeu proxy --port=10001'
alias kprodus_proxy='kprodus proxy --port=10001'

alias   kprod_port_fwd='kprod   port-forward --v=6 --address 0.0.0.0 service/'
alias kprodcn_port_fwd='kprodcn port-forward --v=6 --address 0.0.0.0 service/'
alias kprodeu_port_fwd='kprodeu port-forward --v=6 --address 0.0.0.0 service/'
alias kprodus_port_fwd='kprodus port-forward --v=6 --address 0.0.0.0 service/'

alias    kprod_consul='kprod    port-forward service/consul 8300 8301 8302 8500 8600'
alias  kprodcn_consul='kprodcn  port-forward service/consul 8300 8301 8302 8500 8600'
alias  kprodeu_consul='kprodeu  port-forward service/consul 8300 8301 8302 8500 8600'
alias  kprodus_consul='kprodus  port-forward service/consul 8300 8301 8302 8500 8600'


alias   kprod_rabbit='kprod    port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kprodcn_rabbit='kprodcn  port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kprodeu_rabbit='kprodeu  port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kprodus_rabbit='kprodus  port-forward service/rabbitmq-ha 4369 5672 15672 15692'

function kprod_exec()
{
    kprod exec -it $@ -- sh -c '(bash || ash || sh)'
}

function  kprodcn_exec()
{
    kprodcn exec -it $@ -- sh -c '(bash || ash || sh)'
}
