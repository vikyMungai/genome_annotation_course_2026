#!/bin/bash

function create_dir {
# create a directory if it does not already exist
#   Params: 
#           $1: absolute path to the directory to be created
    local DIR="$1"
    if [ ! -d "$DIR" ]; then 
        echo "directory ${DIR} created"
        # the -p option creates parent directories if they do not already exist
        mkdir -p "$DIR"
    fi 
}