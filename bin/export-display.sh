#!/bin/bash

ADDR=$(echo $SSH_CLIENT | awk '{print $1}')

if [ $ADDR ]
then
    export DISPLAY=$ADDR:0.0
    exit 0
fi

if [[ $WSL_HOST_IP ]]
then
    # export DISPLAY=localhost:0.0
    export DISPLAY=$WSL_HOST_IP:0.0
    exit 0
fi

export DISPLAY=localhost:0.0
