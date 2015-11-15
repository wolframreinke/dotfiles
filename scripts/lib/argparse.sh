#! /bin/bash
# ----------------------------------------------------------------------------
# File    : argparse.sh
# Author  : Wolfram Reinke
# Created : 04/21/15
# ----------------------------------------------------------------------------
# 
# Parses command line arguments in an event-driven way.
#
# ----------------------------------------------------------------------------

source $HOME/scripts/lib/map.sh

function __exit_unknown
{
        echo "Unknown option: ${1}" >&2
        exit 1
}

# ----------------------------------------------------------------------------
# FUNCTION parse_args( args, handler_map )
#
# Parses the arguments and calls for each option (starting with - or --) the
# corresponding event handler in the handler_map. For arguments, the event
# handler on "argument" is called.
# ----------------------------------------------------------------------------
function parse_args
{
        local ARGS="${1}"
        local HANDLERS="${2}"

        for ARGUMENT in ${ARGS}
        do
                if [[ ${ARGUMENT} == -* ]]
                then
                        local OPTIONS="${ARGUMENT:1}"

                        if [[ ${OPTIONS} == -* ]]
                        then
                                local NAME="${OPTIONS:1}"

                                $(map_get "${HANDLERS}"                 \
                                          "${NAME}"                     \
                                          '__exit_unknown "${NAME}"')
                        else
                                for OPTION in $(grep -o . <<< "${OPTIONS}")
                                do
                                        $(map_get "${HANDLERS}"         \
                                                  "${OPTION}"           \
                                                  '__exit_unknown "${OPTION}"')
                                done

                        fi

                else
                        local CMD=$(map_get "${HANDLERS}" argument :)
                        echo $CMD
                        eval "$CMD ${ARGUMENT}"
                fi

        done

}
