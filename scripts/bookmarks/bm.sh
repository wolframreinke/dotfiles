#! /bin/bash

# ==============================================================================
#
# This script manages bookmark for the user. He can add any location on the
# computer to his bookmarks, and jump to this bookmark by specifying its name.
# Also, the user can search the list of stored bookmarks
#
# ==============================================================================

DEBUG="false"

function _debug
{
    if [ ${DEBUG} == "true" ]
    then
        echo -e "[DEBUG]\t${1}"
    fi

    return 0
}

function _display_help
{
    cat ${HOME}/scripts/bookmarks/bm.help
    return 0
}

function _bm_main
{
    local BOOKMARK_STORE="${HOME}/scripts/bookmarks"
    local BOOKMARK_STORE_PER="${BOOKMARK_STORE}/permanent"
    local BOOKMARK_STORE_TMP="${HOME}/scripts/bookmarks/temporary"
    local BOOKMARK_SCRIPT="${HOME}/scripts/bookmarks/bm.sh"

    # --------------------------------
    # Parse the command line arguments
    # --------------------------------

    # These values are set during the parsing procedure
    local ARGUMENT="undefined"
    local ARG_PATH="undefined"
    local MODE="default"
    local TEMPORARY="false"

    # iterate over all given arguments
    while [ $# -gt 0 ]
    do
        CURRENT_OPT=${1}
        shift

        case ${CURRENT_OPT} in

        # Display the help message
        -h|--help)
            _display_help;
            return 0
            ;;

        # switch "save" mode. The current position will be saved with
        # the given name
        -s|--set)
            MODE="save"
            ;;

        # switch to "goto" mode. The current position will be changed to
        # the specified bookmark
        -g|--goto)
            MODE="goto"
            ;;

        # display all available bookmarks in aplhabetical order
        -l|--list)

            for DIRECTORY in permanent temporary; do

                _debug "${DIRECTORY}"

                echo -e "\n${DIRECTORY}" | tr '[:lower:]' '[:upper:]'
                printf "%80s\n" | tr ' ' -
                for FILENAME in ${BOOKMARK_STORE}/${DIRECTORY}/*.bm; do

                    if [ "${FILENAME}" != "${BOOKMARK_STORE}/${DIRECTORY}/*.bm" ]; then

                        _debug "${FILENAME}"

                        local LEFT=$(echo ${FILENAME} | grep -Poi '(?<=\/)((?!\/).)*?(?=\.bm)')
                        local RIGHT=$(cat ${FILENAME})
                        if [ ! -e "${RIGHT}" ]; then
                            printf "%-20s - \e[0;31m%s\e[0m\n" ${LEFT} ${RIGHT}
                        else
                            printf "%-20s - %s\n" ${LEFT} ${RIGHT}
                        fi
                    else
                        echo "(none)"
                    fi
                done
                echo ""
            done

            return 0;
            ;;

        # delete the specified bookmark
        -r|--remove)
            MODE="rm"
            ;;

                -p|--print)
                        MODE="print"
                        ;;

        -t|--tmp)
            TEMPORARY="true"
            ;;

        -ct|--cleartmp)
            rm ${BOOKMARK_STORE_TMP}/*.bm > /dev/null 2>&1;
            return 0
            ;;

        # unknown options start with a -, but the rest is unrecognized
       -*)
            echo "Unknown option ${CURRENT_OPT}"
            return 1
            ;;

        # the argument to the chosen operation
        *)
            ARGUMENT=$(echo ${CURRENT_OPT} | sed 's_^\([^/]*\).*_\1_g')
            ARGUMENT=${CURRENT_OPT%%/*}
            ARG_PATH=${CURRENT_OPT#*/}

            if [ "${ARGUMENT}" == "$ARG_PATH" ]; then
                    ARG_PATH="."
            fi
            ;;

        esac
    done

    # the user has not chosen either --list --save or --goto.  if the specified
    # bookmark exists, the corresponding directory is opened, if not, a new
    # bookmark with the specified name is created at the current position
    if [ ${MODE} == "default" ]; then

        if [ ${ARGUMENT} == "undefined" ]; then
            echo -n "Name of the bookmark: "
            read ARGUMENT
        fi

        if [   -e ${BOOKMARK_STORE_PER}/${ARGUMENT}".bm" \
            -o -e ${BOOKMARK_STORE_TMP}/${ARGUMENT}".bm" ]; then
            _bm_main --goto $ARGUMENT/$ARG_PATH
        else

            if [ ${TEMPORARY} == "false" ]; then
                _bm_main --set ${ARGUMENT}
            else
                _bm_main --tmp --set ${ARGUMENT}
            fi
        fi

    elif [ ${MODE} == "save" ]; then

        if [ ${ARGUMENT} == "undefined" ]; then

            echo -n "Name for the new bookmark: "
            read ARGUMENT
        else

            echo -n "Are you sure, you want to create a new bookmark? (Y/N): "
            read RESPONSE

            if [ "${RESPONSE}" != "Y" ]; then
                echo Aborting.
                return
            fi
        fi

        if [ ${TEMPORARY} == "false" ]; then
            echo ${PWD} > ${BOOKMARK_STORE_PER}/${ARGUMENT}".bm"
        else
            echo ${PWD} > ${BOOKMARK_STORE_TMP}/${ARGUMENT}".bm"
        fi

    elif [ ${MODE} == "rm" ]; then

        if [ ${ARGUMENT} == "undefined" ]; then
            echo -n "Name of the bookmark to delete: "
            read ARGUMENT
        fi


        rm ${BOOKMARK_STORE_PER}/${ARGUMENT}".bm" > /dev/null 2>&1
        rm ${BOOKMARK_STORE_TMP}/${ARGUMENT}".bm" > /dev/null 2>&1

        return 0
        elif [ ${MODE} == "print" ]; then

                if [ ${ARGUMENT} == "undefined" ]; then
                        echo -n "Name of the bookmark to primt: "
                        read ARGUMENT
                fi

                TARGET=$(cat ${BOOKMARK_STORE_PER}/${ARGUMENT}".bm" 2> /dev/null)
                if [ -z ${TARGET} ]; then
                        TARGET=$(cat ${BOOKMARK_STORE_TMP}/${ARGUMENT}".bm" 2> /dev/null)
                fi

                echo ${TARGET}
    else
        if [ ${ARGUMENT} == "undefined" ]; then
            echo -n "Name of the desired bookmark: "
            read ARGUMENT
        fi

        _debug "ARGUMENT = ${ARGUMENT}"

        TARGET=$(cat ${BOOKMARK_STORE_PER}/${ARGUMENT}".bm" 2> /dev/null)

        _debug "TARGET = $TARGET"

        if [ -z ${TARGET} ]; then
            TARGET=$(cat ${BOOKMARK_STORE_TMP}/${ARGUMENT}".bm" 2> /dev/null)
        fi

        _debug "TARGET = ${TARGET}"

        if [ ${TARGET} ]; then
            cd ${TARGET}/${ARG_PATH}
        else
            echo "No such bookmark."
            return 1
        fi
    fi
}

alias bm=_bm_main
