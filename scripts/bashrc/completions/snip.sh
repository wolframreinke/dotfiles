#! /usr/bin/env bash

function debug {
    [ ${DEBUG} == true ] && echo "[DEBUG] $1"
}

function _complete_snip
{
    DEBUG=false

    debug ""

    local SNIPPATH=${HOME}/scripts/snippets/snips
    local SNIPPATH_LEN=$(echo ${SNIPPATH}/ | wc -c)

    local CURRENT=${COMP_WORDS[COMP_CWORD]}

    debug "snippath = ${SNIPPATH}"
    debug "current = ${CURRENT}"

    local POSS=$(find ${SNIPPATH} -type f | cut -c ${SNIPPATH_LEN}-)
    debug "poss = ${POSS}"

    COMPREPLY=( $(compgen -W "${POSS}" -- ${CURRENT}) )
    debug "compreply = ${COMPREPLY}"
}

complete -F _complete_snip snip
