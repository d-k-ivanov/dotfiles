#!/usr/bin/env bash

# Set PATHs
platform=`uname`
case $platform in
    Linux )
        # CUDA
        [[ -d /usr/local/cuda-11.0/lib64 ]] && export LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64:$LD_LIBRARY_PATH
        [[ -d /usr/local/cuda-12.2/lib64 ]] && export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:$LD_LIBRARY_PATH
        ;;
    Darwin )
        ;;
    MSYS_NT-10.0 )
        ;;
esac
