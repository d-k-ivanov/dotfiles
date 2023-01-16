#!/usr/bin/env bash

## Docker
alias    di='docker images'
alias    dc='docker ps -a'
alias  dcle='docker rm $(docker ps -aqf status=exited)'
alias  dclc='docker rm $(docker ps -aqf status=created)'
alias  dcla='docker rm $(docker ps -aqf status=exited) || docker rmi $(docker images -qf dangling=true) || docker volume rm $(docker volume ls -qf dangling=true)'
alias  dcli='docker rmi $(docker images -q)'
alias dclif='docker rmi -f $(docker images -q)'

# Run docker container in interactive mode
alias dri='docker run --rm -it'
alias dri_entry='docker run --rm -it --entrypoint /bin/sh'
alias dri_pwd='docker run --rm -it -v ${PWD}:/project'
alias dri_pwd_ray='docker run --rm -it -v ${PWD}:/project -p 6379:6379 -p 8000:8000 -p 8076:8076 -p 8265:8265 -p 10001:10001'

# Rewrite entry point to shell
alias desh='docker run --rm -it --entrypoint /bin/sh'

# inspect docker images
function dc_trace_cmd()
{
    local parent=`docker inspect -f '{{ .Parent }}' $1` 2>/dev/null
    declare -i level=$2
    echo ${level}: `docker inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null`
    level=level+1
    if [ "${parent}" != "" ]
    then
        echo ${level}: $parent
        dc_trace_cmd $parent $level
    fi
}

function docker_search_logs()
{
    if [ -z "${1}" ]
    then
        echo "Usage: docker_search_logs Search_String"
        echo
    else
        docker ps -a --format "{{.Names}}" | xargs -i bash -c "docker logs {} |& sed -ne 's/^\[\(2020[0-9.:T-]*Z\)\(.*\)/\1 {}\t\2/p'" | grep "${1}" | sort -st ' ' -nk1 | less
    fi
}

alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage -sV=1.36"
alias dive="docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"

## Podman
alias    pi='podman images'
alias    pc='podman ps -a'
alias  pcle='podman rm $(podman ps -aqf status=exited)'
alias  pclc='podman rm $(podman ps -aqf status=created)'
alias  pcla='podman rm $(podman ps -aqf status=exited) || podman rmi $(podman images -qf dangling=true) || podman volume rm $(podman volume ls -qf dangling=true)'
alias  pcli='podman rmi $(podman images -q)'
alias pclif='podman rmi -f $(podman images -q)'

# Run podman container in interactive mode
alias pri='podman run --rm -it'
alias pri_entry='podman run --rm -it --entrypoint /bin/sh'
alias pri_pwd='podman run --rm -it -v ${PWD}:/project'
alias pri_pwd_ray='podman run --rm -it -v ${PWD}:/project -p 6379:6379 -p 8000:8000 -p 8076:8076 -p 8265:8265 -p 10001:10001'

# Rewrite entry point to shell
alias pesh='podman run --rm -it --entrypoint /bin/sh'

# inspect podman images
function pc_trace_cmd()
{
    local parent=`podman inspect -f '{{ .Parent }}' $1` 2>/dev/null
    declare -i level=$2
    echo ${level}: `podman inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null`
    level=level+1
    if [ "${parent}" != "" ]
    then
        echo ${level}: $parent
        pc_trace_cmd $parent $level
    fi
}

function podman_search_logs()
{
    if [ -z "${1}" ]
    then
        echo "Usage: podman_search_logs Search_String"
        echo
    else
        podman ps -a --format "{{.Names}}" | xargs -i bash -c "podman logs {} |& sed -ne 's/^\[\(2020[0-9.:T-]*Z\)\(.*\)/\1 {}\t\2/p'" | grep "${1}" | sort -st ' ' -nk1 | less
    fi
}

alias pfimage="podman run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage -sV=1.36"
alias pive="podman run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"
