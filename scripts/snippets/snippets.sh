#! /bin/bash
# ----------------------------------------------------------------------------
# File    : snippets.sh
# Author  : Wolfram Reinke
# Created : 07/27/15
# ----------------------------------------------------------------------------
#
# Script for managing executable snippets. Existing snippets can be called as
# follows:
#
#   > snip <snip_path>
#
# where <snip_path> is a namespace path like namespace/subnamespace/snippet.
# New snippets can be added to the snippet store with
#
#   > snip add <local_file> <snip_path>
#
# Snippets can be removed with
#
#  > snip remove <snip_path>
#
# All existing snippets in a namespace are listed with
#
#  > snip list [<snip_path>]
#
# ----------------------------------------------------------------------------

DEBUG=true
function debug {
    [ "${DEBUG}" == true ] && echo "[DEBUG] ${1}"
}

function die { 
    echo ${1} >&2 ; exit 1
}

# ----------------------------------------------------------------------------
# FUNCTION main( ... )
#
# Scripts main function.
# ----------------------------------------------------------------------------
function main {

    local SNIP_STORE="${HOME}/scripts/snippets/snips"
    local SNIP_DIR="${HOME}/scripts/snippets"

    if [ $# -eq 0 ]; then
        echo "Too few arguments. Use ${0} help for more information." >&2
        return 1
    fi

    local ACTION="exec"

    if [ ! -z "$(echo ${1} | grep -P 'help|add|remove|exec|list|with')" ]; then
        ACTION=${1}
        shift
    fi

    if   [ "${ACTION}" == add ]; then

        [ $# -eq 0 ] && \
            die "Too few arguments. 'add' requires a file and a name"

        local FILE_PATH=${1}
        shift

        [ $# -eq 0 ] && \
            die "Too few arguments. 'add' requires a file and a name"

        local NAME=${1}

        mkdir -p $(dirname ${SNIP_STORE}${GLOBAL_NAME}/${NAME}) > /dev/null 2>&1
        cp ${FILE_PATH} ${SNIP_STORE}${GLOBAL_NAME}/${NAME} > /dev/null 2>&1 ||\
            die "Could not copy snippet."
        chmod +x ${SNIP_STORE}${GLOBAL_NAME}/${NAME} > /dev/null 2>&1 || \
            die "Could not copy snippet."

    elif [ "${ACTION}" == help ]; then

        cat ${SNIP_DIR}/snippets.help
        return 0

    elif [ "${ACTION}" == remove ]; then

        [ $# -eq 0 ] && \
            die "Too few arguments. 'remove' requires a name"

        local NAME=${1}

        COUNT=$(find ${SNIP_STORE}${GLOBAL_NAME}/${NAME} | wc -l)
        echo -n "Are you sure you want to remove ${COUNT} elements? [y/n] "
        read RESPONSE
        if [ "${RESPONSE}" == y ]; then
            rm -rf ${SNIP_STORE}${GLOBAL_NAME}/${NAME} > /dev/null 2>&1 || \
                die "Could not delete snippet(s)."
        fi

    elif [ "${ACTION}" == exec ]; then

        [ $# -eq 0 ] && \
            die "Too few arguments. Provide the name of the snippet to execute."

        local NAME=${1}
        shift

        if [ -d ${SNIP_STORE}${GLOBAL_NAME}/${NAME} ]; then
            tree ${SNIP_STORE}${GLOBAL_NAME}/${NAME}
        else
            ${SNIP_STORE}${GLOBAL_NAME}/${NAME} $@ || die "Execution failed."
        fi

    elif [ "${ACTION}" == list ]; then

        [ $# -ne 1 ] && local NAME=${1}
        [ ! -z "${NAME}" ] && local NAME=/${NAME}

        tree ${SNIP_STORE}${GLOBAL_NAME}${NAME}

    elif [ "${ACTION}" == with ]; then

        [ $# -eq 0 ] && \
            die "Too few arguments. With requires a name."

        export GLOBAL_NAME=/${1}
        shift

        main $@
    fi
}

main "$@"
