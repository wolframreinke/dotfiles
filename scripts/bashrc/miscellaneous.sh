#! /bin/bash

function followlinks {
    echo -n " -> ${1}"
    if [ -h "${1}" ]; then
        newpath=$(readlink -f "${1}")
        followlinks "${newpath}"
    fi
}

function slwhich {
    if [ "${1}" ]; then
        echo -n ${1}
        path=$(which "${1}")
        if [ "${path}" ]; then
            followlinks "${path}"
        fi
        echo
    fi
}
