#! /usr/bin/env bash
#
# This script manages .gdbinit files. The user can pass the name of a gdb mode
# to this script, and it will copy the corresponding .gdbinit file into the
# user's home directory. Also it can remove the current .gdbinit file from the
# home directory to reset gdb mode.

DEBUG="false"
function debug { [ ${DEBUG} == true ] && echo "[DEBUG] ${1}"; }

function _gdbmode_main
{
    local GDBINIT_HOME="${HOME}/scripts/gdbmode"
    local GDBINIT_STORE="${GDBINIT_HOME}/gdbinits"

    # Parse the command line arguments

    # These values are set during the parsing procedure
    local MODIFIER=load
    local GDBMODE=undefined
    local GDBINIT=undefined

    debug "initialisation done."

    # iterate over all given arguments
    while [ $# -gt 0 ]; do

        CURRENT_OPT=$1
        shift

        debug "CURRENT_OPT = ${CURRENT_OPT}"

        case ${CURRENT_OPT} in

        # Display the help message
        -h|--help)
            cat ${GDBINIT_HOME}/gdbmode.help
            return 0
            ;;

        # switch "save" mode. The current position will be saved with the given
        # name
        -a|--add)
            MODIFIER="save"
            ;;

        -l|--load)
            MODIFIER="load"
            ;;

        # display all available bookmarks in apltical order
        --list)
            ls $GDBINIT_STORE | sort
            return 0
            ;;

        # delete the specified bookmark
        -r|--reset)
            MODIFIER="reset"
            ;;

        # unknown options start with a -, but the rest is unrecognized
        -*)
            echo "Unknown option ${CURRENT_OPT}"
            return 1
            ;;

        # the argument to the chosen operation
        *)
            if [ ${GDBMODE} == undefined ]
            then
                GDBMODE=${CURRENT_OPT}
            else
                GDBINIT=${CURRENT_OPT}
            fi

            ;;

        esac
    done

    # -------------------------------------------
    # Interprete the command line arguments
    # -------------------------------------------

    if [ $MODIFIER == "load" ]
    then

        # if the user has not provided a gdb mode name, he is asked to
        # choose one
        if [ "$GDBMODE" == "undefined" ]
        then

            echo -n "Name of the gdb-mode > "
            read GDBMODE

        fi

        # this is repeated, until he finally enters the name of an existing
        # gdb mode
        while [ ! -f "$GDBINIT_STORE/$GDBMODE" ]
        do

            echo -e "There is no such gdb-mode.\n"
            echo -n "Name of the gdb-mode > "
            read GDBMODE

        done

        # then, the corresponding .gdbinit file is copied to the
        # home directory of the user to make it gdb-default
        cp $GDBINIT_STORE/$GDBMODE $HOME/.gdbinit


    elif [ $MODIFIER == "save" ]
    then

        # Check whether the user has provided a gdb mode name
        # if not, ask him for a name
        if [ "$GDBMODE" == "undefined" ]
        then

            echo -n "Name of the gdb-mode > "
            read GDBMODE

        fi

        # if there already is a .gdbinit file with this name,
        # then the user is asked again.
        while [ -f "$GDBMODE" ]
        do

            echo -e "Name already occupied.\n"
            echo -n "Name of the gdb-mode > "
            read GDBMODE

        done

        # if the user has not provided a .gdbinit file, then
        # he is asked to choose one.
        if [ "$GDBINIT" == "undefined" ]
        then

            echo -n ".gdbinit file > "
            read GDBINIT

        fi

        # If the file does not exist, the user is asked to enter
        # the real name of the new .gdbinit file.
        while [ ! -f "$GDBINIT" ]
        do

            debug "$GDBINIT"
            echo -e "There is no such file.\n"
            echo -n ".gdbinit file > "
            read GDBINIT

        done

        cp $GDBINIT $GDBINIT_STORE/$GDBMODE

    elif [ $MODIFIER == "reset" ]
    then

        # delete the .gdbinit file in the user's home directory, if it exists.
        rm $HOME/.gdbinit

    fi
}

_gdbmode_main "$@"

#alias gdbmode=_gdbmode_main
