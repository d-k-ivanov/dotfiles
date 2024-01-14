#!/usr/bin/env bash

LD_LIBRARY_PATH=::
# Set PATHs
platform=`uname`
case $platform in
    Linux )
        [[ -d /usr/lib64 ]]     && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64
        [[ -d /usr/lib64/mkl ]] && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/mkl
        # CUDA
        [[ -d /usr/local/cuda-12.3/lib64 ]] && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.3/lib64
        [[ -d /usr/local/cuda-12.2/lib64 ]] && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.2/lib64
        [[ -d /usr/local/cuda-11.0/lib64 ]] && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.0/lib64
        ;;
    Darwin )
        ;;
    MSYS_NT-10.0 )
        ;;
esac
