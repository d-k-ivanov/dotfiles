#!/usr/bin/env bash

alias     kdev='kubectl --kubeconfig ~/.kube/dev'
alias   kstage='kubectl --kubeconfig ~/.kube/stage'
alias    kprod='kubectl --kubeconfig ~/.kube/prod'
alias   kdevcn='kubectl --kubeconfig ~/.kube/devcn'
alias kstagecn='kubectl --kubeconfig ~/.kube/stagecn'
alias  kprodcn='kubectl --kubeconfig ~/.kube/prodcn'
alias      kws='kubectl --kubeconfig ~/.kube/ws'

alias     hdev='helm --kubeconfig ~/.kube/dev'
alias   hstage='helm --kubeconfig ~/.kube/stage'
alias    hprod='helm --kubeconfig ~/.kube/prod'
alias   hdevcn='helm --kubeconfig ~/.kube/devcn'
alias hstagecn='helm --kubeconfig ~/.kube/stagecn'
alias  hprodcn='helm --kubeconfig ~/.kube/prodcn'
alias      hws='helm --kubeconfig ~/.kube/ws'

alias     kdev_proxy='kubectl --kubeconfig ~/.kube/dev      proxy --port=10001'
alias   kstage_proxy='kubectl --kubeconfig ~/.kube/stage    proxy --port=10001'
alias    kprod_proxy='kubectl --kubeconfig ~/.kube/prod     proxy --port=10001'
alias   kdevcn_proxy='kubectl --kubeconfig ~/.kube/devcn    proxy --port=10001'
alias kstagecn_proxy='kubectl --kubeconfig ~/.kube/stagecn  proxy --port=10001'
alias  kprodcn_proxy='kubectl --kubeconfig ~/.kube/prodcn   proxy --port=10001'
alias      kws_proxy='kubectl --kubeconfig ~/.kube/ws       proxy --port=10001'

alias     kdev_port_fwd='kubectl --kubeconfig ~/.kube/dev     port-forward --v=6 --address 0.0.0.0 service/'
alias   kstage_port_fwd='kubectl --kubeconfig ~/.kube/stage   port-forward --v=6 --address 0.0.0.0 service/'
alias    kprod_port_fwd='kubectl --kubeconfig ~/.kube/prod    port-forward --v=6 --address 0.0.0.0 service/'
alias   kdevcn_port_fwd='kubectl --kubeconfig ~/.kube/devcn   port-forward --v=6 --address 0.0.0.0 service/'
alias kstagecn_port_fwd='kubectl --kubeconfig ~/.kube/stagecn port-forward --v=6 --address 0.0.0.0 service/'
alias  kprodcn_port_fwd='kubectl --kubeconfig ~/.kube/prodcn  port-forward --v=6 --address 0.0.0.0 service/'
alias      kws_port_fwd='kubectl --kubeconfig ~/.kube/ws      port-forward --v=6 --address 0.0.0.0 service/'

alias     kdev_consul='kubectl --kubeconfig ~/.kube/dev     port-forward service/consul 8300 8301 8302 8500 8600'
alias   kstage_consul='kubectl --kubeconfig ~/.kube/stage   port-forward service/consul 8300 8301 8302 8500 8600'
alias    kprod_consul='kubectl --kubeconfig ~/.kube/prod    port-forward service/consul 8300 8301 8302 8500 8600'
alias   kdevcn_consul='kubectl --kubeconfig ~/.kube/devcn   port-forward service/consul 8300 8301 8302 8500 8600'
alias kstagecn_consul='kubectl --kubeconfig ~/.kube/stagecn port-forward service/consul 8300 8301 8302 8500 8600'
alias  kprodcn_consul='kubectl --kubeconfig ~/.kube/prodcn  port-forward service/consul 8300 8301 8302 8500 8600'
alias      kws_consul='kubectl --kubeconfig ~/.kube/ws      port-forward service/consul 8300 8301 8302 8500 8600'

alias     kdev_rabbit='kubectl --kubeconfig ~/.kube/dev     port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias   kstage_rabbit='kubectl --kubeconfig ~/.kube/stage   port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias    kprod_rabbit='kubectl --kubeconfig ~/.kube/prod    port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias   kdevcn_rabbit='kubectl --kubeconfig ~/.kube/devcn   port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias kstagecn_rabbit='kubectl --kubeconfig ~/.kube/stagecn port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias  kprodcn_rabbit='kubectl --kubeconfig ~/.kube/prodcn  port-forward service/rabbitmq-ha 4369 5672 15672 15692'
alias      kws_rabbit='kubectl --kubeconfig ~/.kube/ws      port-forward service/rabbitmq-ha 4369 5672 15672 15692'

function kdev_exec()
{
    kubectl --kubeconfig ~/.kube/dev     exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kstage_exec()
{
    kubectl --kubeconfig ~/.kube/stage   exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kprod_exec()
{
    kubectl --kubeconfig ~/.kube/prod    exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kdevcn_exec()
{
    kubectl --kubeconfig ~/.kube/devcn   exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kstagecn_exec()
{
    kubectl --kubeconfig ~/.kube/stagecn exec -it $@ -- sh -c '(bash || ash || sh)'
}

function  kprodcn_exec()
{
    kubectl --kubeconfig ~/.kube/prodcn  exec -it $@ -- sh -c '(bash || ash || sh)'
}

function kws_exec()
{
    kubectl --kubeconfig ~/.kube/ws      exec -it $@ -- sh -c '(bash || ash || sh)'
}

# alias     kdev_admin="kubectl --kubeconfig ~/.kube/dev     -n kube-system describe secret $(kubectl --kubeconfig ~/.kube/dev     -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias   kstage_admin="kubectl --kubeconfig ~/.kube/stage   -n kube-system describe secret $(kubectl --kubeconfig ~/.kube/stage   -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias    kprod_admin="kubectl --kubeconfig ~/.kube/prod    -n kube-system describe secret $(kubectl --kubeconfig ~/.kube/prod    -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias   kdevcn_admin="kubectl --kubeconfig ~/.kube/devcn   -n kube-system describe secret $(kubectl --kubeconfig ~/.kube/devcn   -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias kstagecn_admin="kubectl --kubeconfig ~/.kube/stagecn -n kube-system describe secret $(kubectl --kubeconfig ~/.kube/stagecn -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
# alias  kprodcn_admin="kubectl --kubeconfig ~/.kube/prodcn  -n kube-system describe secret $(kubectl --kubeconfig ~/.kube/prodcn  -n kube-system get secret | grep admin-user-token | awk '{print $1}')"

function kimages
{
    echo "WIP"
}

