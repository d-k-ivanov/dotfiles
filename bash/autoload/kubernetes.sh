#!/usr/bin/env bash

alias kdocker='kubectl --context docker-desktop'
alias hdocker='helm --kube-context docker-desktop'

## =============== DevOps environment =============== ##
alias   kdevops='kubectl --context devops'
alias kdevopscn='kubectl --context devopscn'
alias kdevopseu='kubectl --context devopseu'
alias kdevopsus='kubectl --context devopsus'

alias   hdevops='helm --kube-context devops'
alias hdevopscn='helm --kube-context devopscn'
alias hdevopseu='helm --kube-context devopseu'
alias hdevopsus='helm --kube-context devopsus'

## =============== Dev environment    =============== ##
alias     kdev='kubectl --context dev'
alias   kdevcn='kubectl --context devcn'
alias   kdeveu='kubectl --context deveu'
alias   kdevus='kubectl --context devus'

alias     hdev='helm --kube-context dev'
alias   hdevcn='helm --kube-context devcn'
alias   hdeveu='helm --kube-context deveu'
alias   hdevus='helm --kube-context devus'

## =============== Stage environment  =============== ##
alias   kstage='kubectl --context stage'
alias kstagecn='kubectl --context stagecn'
alias kstageeu='kubectl --context stageeu'
alias kstageus='kubectl --context stageus'

alias   hstage='helm --kube-context stage'
alias hstagecn='helm --kube-context stagecn'
alias hstageeu='helm --kube-context stageeu'
alias hstageus='helm --kube-context stageus'

## =============== Prod environment   =============== ##
alias    kprod='kubectl --context prod'
alias  kprodcn='kubectl --context prodcn'
alias  kprodeu='kubectl --context prodeu'
alias  kprodus='kubectl --context produs'

alias    hprod='helm --kube-context prod'
alias  hprodcn='helm --kube-context prodcn'
alias  hprodeu='helm --kube-context prodeu'
alias  hprodus='helm --kube-context produs'

alias     kdev_proxy='kdev      proxy --port=10001'
alias  kdevops_proxy='kdevops   proxy --port=10001'
alias   kstage_proxy='kstage    proxy --port=10001'
alias    kprod_proxy='kprod     proxy --port=10001'
alias   kdevcn_proxy='kdevcn    proxy --port=10001'
alias kstagecn_proxy='kstagecn  proxy --port=10001'
alias  kprodcn_proxy='kprodcn   proxy --port=10001'
alias      kws_proxy='kdocker   proxy --port=10001'

alias     kdev_port_fwd='kdev     port-forward --v=6 --address 0.0.0.0 service/'
alias  kdevops_port_fwd='kdevops  port-forward --v=6 --address 0.0.0.0 service/'
alias   kstage_port_fwd='kstage   port-forward --v=6 --address 0.0.0.0 service/'
alias    kprod_port_fwd='kprod    port-forward --v=6 --address 0.0.0.0 service/'
alias   kdevcn_port_fwd='kdevcn   port-forward --v=6 --address 0.0.0.0 service/'
alias kstagecn_port_fwd='kstagecn port-forward --v=6 --address 0.0.0.0 service/'
alias  kprodcn_port_fwd='kprodcn  port-forward --v=6 --address 0.0.0.0 service/'
alias      kws_port_fwd='kdocker  port-forward --v=6 --address 0.0.0.0 service/'

alias     kdev_consul='kdev     port-forward service/consul 8300 8301 8302 8500 8600'
alias  kdevops_consul='kdevops  port-forward service/consul 8300 8301 8302 8500 8600'
alias   kstage_consul='kstage   port-forward service/consul 8300 8301 8302 8500 8600'
alias    kprod_consul='kprod    port-forward service/consul 8300 8301 8302 8500 8600'
alias   kdevcn_consul='kdevcn   port-forward service/consul 8300 8301 8302 8500 8600'
alias kstagecn_consul='kstagecn port-forward service/consul 8300 8301 8302 8500 8600'
alias  kprodcn_consul='kprodcn  port-forward service/consul 8300 8301 8302 8500 8600'
alias      kws_consul='kdocker  port-forward service/consul 8300 8301 8302 8500 8600'

alias     kdev_rabbit='kdev     port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias  kdevops_rabbit='kdevops  port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias   kstage_rabbit='kstage   port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias    kprod_rabbit='kprod    port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias   kdevcn_rabbit='kdevcn   port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kstagecn_rabbit='kstagecn port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias  kprodcn_rabbit='kprodcn  port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias      kws_rabbit='kdocker  port-forward service/rabbitmq-ha 4369 5672 15672 15692'

function kdev_exec()
{
    kdev exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kdevops_exec()
{
    kdevops exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kstage_exec()
{
    kstage exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kprod_exec()
{
    kprod exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kdevcn_exec()
{
    kdevcn exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kstagecn_exec()
{
    kstagecn exec -it $@ -- sh -c '(bash || ash || sh)'
}

function  kprodcn_exec()
{
    kprodcn exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kws_exec()
{
    kdocker exec -it $@ -- sh -c '(bash || ash || sh)'
}

# alias     kdev_admin="kdev     -n kube-system describe secret $(kdev     -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias  kdevops_admin="kdevops  -n kube-system describe secret $(kdevops  -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias   kstage_admin="kstage   -n kube-system describe secret $(kstage   -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias    kprod_admin="kprod    -n kube-system describe secret $(kprod    -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias   kdevcn_admin="kdevcn   -n kube-system describe secret $(kdevcn   -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias kstagecn_admin="kstagecn -n kube-system describe secret $(kstagecn -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias  kprodcn_admin="kprodcn  -n kube-system describe secret $(kprodcn  -n kube-system get secret | grep admin-user-token | awk '{print $1}')"

function kimages
{
    echo "WIP"
}
