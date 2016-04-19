#! /bin/bash
# ----------------------------------------------------------------------------
# File    : new.sh
# Author  : Wolfram Reinke
# Created : 06/30/15
# ----------------------------------------------------------------------------
#
# Add a description here
#
# ----------------------------------------------------------------------------

SCRIPT_PATH=$HOME/scripts/new

DEBUG=false
QUIET=false

# ----------------------------------------------------------------------------
# FUNCTION debug( str )
#
# Outputs the specified string if, and only if the global symbol $DEBUG is set
# to "true"
# ----------------------------------------------------------------------------
function debug
{
    if [ "$DEBUG" == true ]; then
        echo "[DEBUG] $1"
    fi
}

# ----------------------------------------------------------------------------
# FUNCTION replace( file, from, to )
#
# Replaces the first occurrence of <from> in <file> with <to>.
# ----------------------------------------------------------------------------
function replace
{
    local FILE="$1"

    local FROM=$(echo "$2" | sed 's_[]/&$*.^[]_\\&_g')
    local TO=$(echo "$3" | sed 's_[]/&$*.^[]_\\&_g')

    debug "replace: in   $FILE"
    debug "replace: from $FROM"
    debug "replace: to   $TO"

    sed "0,/$FROM/{s/$FROM/$TO/g}" "$FILE" > replace_tmp.txt
    mv replace_tmp.txt "$FILE"
}

function replace_all
{
    local FILE="$1"

    local FROM=$(echo "$2" | sed 's_[]/&$*.^[]_\\&_g')
    local TO=$(echo "$3" | sed 's_[]/&$*.^[]_\\&_g')

    debug "replace_all: in   $FILE"
    debug "replace_all: from $FROM"
    debug "replace_all: to   $TO"

    sed "s/$FROM/$TO/g" "$FILE" > replace_tmp.txt
    mv replace_tmp.txt "$FILE"
}

function join
{
    local IFS="$1"
    shift
    echo "$*"
}

function map
{
    function="${1}"
    shift
    for element in ${@}; do
        echo ${element} | ${function}
    done
}

# ----------------------------------------------------------------------------
# FUNCTION loadDefaults()
#
# Loads the default values from the defaults file.
# ----------------------------------------------------------------------------
function loadDefaults
{
    debug "Loading Defaults"
    source "$DEFAULTS_FILE"
}

# ----------------------------------------------------------------------------
# FUNCTION loadDefaults()
#
# Loads the default values from the defaults file.
# ----------------------------------------------------------------------------
function printHelp
{
    cat $SCRIPT_PATH/new.help
}

function listContents
{
    tree --noreport "$1"
}

# ----------------------------------------------------------------------------
# FUNCTION process( template )
#
# Replaces all bash commands in the template with their values.
# ----------------------------------------------------------------------------
function process
{
    # Loads the default variable assignments. For example, the "author"
    # variable is set to "Wolfram Reinke" by default in this file.
    loadDefaults

    local TEMPLATE="$1"


    # Saves the value of IFS to a temporary variable and overrides it
    # afterwards. With this set-up, for loops will split their inputs at
    # newline chars only
    OIFS="$IFS"
    IFS=$'\n'

    for LINE in $(grep -Pi '(?<!%)%\(.+?(?=\))' "$TEMPLATE"); do
        for VAR in $(echo $LINE | grep -Pio '(?<!%)%\(.+?(?=\))'); do

            VAR=$(echo "$VAR" | cut -c3-)

            # Splits the variable into two parts, the name of the
            # variable and its default value for this occurrence.
            # These two values are separated by a '|' pipe char
            debug "var:  $VAR"
            for PART in $(echo "$VAR" | tr '|' "\n"); do
                debug "part: $PART"
                if [ "$NAME" ]; then
                    if [ "$TEXT" ]; then
                        DEFAULT="$PART"
                    else
                        TEXT="$PART"
                    fi
                else
                    NAME="$PART"
                fi
            done

            # If no default value was set, the default value from
            # the defaults file is used instead. However this value
            # is overwritten below, so that this initializes DEFAULT
            # with the value of the variable with that name from its
            # previous occurrence
            if [ -z "$DEFAULT" ]; then
                DEFAULT=$(eval echo \$$NAME)
            fi

            if [ -z "$TEXT" ]; then
                TEXT="$NAME"
            fi

            if [ "$DEFAULT" ]; then
                RESULT="$DEFAULT"
            else
                if [ "$QUIET" == false ]; then
                    echo -n "$TEXT > "
                fi

                read -r RESULT
            fi

            if [ -z "$RESULT" ]; then
                if [ "$DEFAULT" ]; then
                    RESULT="$DEFAULT"
                fi
            fi

            # Saves the name of this variable
            eval "$NAME=\"$RESULT\""

            # replaces the variable statement with its value
            replace "$TEMPLATE" "%($VAR)" "$RESULT"

            unset DEFAULT
            unset NAME
            unset RESULT
            unset TEXT
        done
    done

    for CMD in $(grep -Pio '(?<!\$)\$\(.+?\)' "$TEMPLATE"); do
        debug "cmd:  $CMD"
        eval "RESULT=\"$CMD\""

        replace "$TEMPLATE" "$CMD" "$RESULT"
    done

    for SETTING in $(grep -Pio '(?<!&)&\(.+?=.+?(?=\))' "$TEMPLATE"); do
        SETTING=$(echo "$SETTING" | cut -c3-)

        debug "set:  $SETTING"
        eval "$SETTING"

        # replaces the variable statement with its value
        replace "$TEMPLATE" "&($SETTING)" ""
    done

    replace_all "$TEMPLATE" '%%' '%'
    replace_all "$TEMPLATE" '$$' '$'
    replace_all "$TEMPLATE" '&&' '&'

    IFS="$OIFS"
}

# ----------------------------------------------------------------------------
# FUNCTION main( ... )
#
# Scripts main function.
# ----------------------------------------------------------------------------
function main
{
    local DEFAULTS_FILE="$SCRIPT_PATH/defaults.sh"
    local TEMPLATE_STORE="$SCRIPT_PATH/templates"

    local MODE="new"
    local VIM=false
    local ARGUMENTS=""

    while [ $# -gt 0 ]; do
        CURRENT_OPT=$1
        shift

        case ${CURRENT_OPT} in

            -h|--help)
                printHelp
                return 0
                ;;

            -d|--debug)
                DEBUG=true
                ;;

            -q|--quiet)
                DEBUG=false
                QUIET=true
                ;;

            -l|--list)
                MODE="list"
                ;;

            -v|--vim)
                MODE="new"
                VIM=true
                ;;

            -*)
                echo "Unknown option ${CURRENT_OPT}" 2>&1
                return 1
                ;;

            *)
                ARGUMENTS="${ARGUMENTS} ${CURRENT_OPT}"
                ;;
        esac
    done

    # If mode is "list" only, then simply all templates are listed.
    if [ "$MODE" == "list" ]; then
        listContents "${TEMPLATE_STORE}"
        exit 0
    fi

    # Converts uppercase to lowercase and joins the arguments to form the
    # required path
    local TEMPLATE_NAME=$(join / $(map "tr [:upper:] [:lower:]" ${ARGUMENTS}))
    local TEMPLATE_NAME="${TEMPLATE_STORE}/${TEMPLATE_NAME}"
    debug "Using template $TEMPLATE_NAME"

    # If the template path is not a real template but only some directory in
    # between, then the contents of this directors are listed
    if [ -d "${TEMPLATE_NAME}" ]; then
        listContents "${TEMPLATE_NAME}"
        exit 0
    fi

    NEWFILE_NAME="$(basename ${TEMPLATE_NAME})_new"
    cp "${TEMPLATE_NAME}" ./${NEWFILE_NAME}

    process "${NEWFILE_NAME}"

    # FILENAME has been set by the template, hopefully at least.
    if [ "$FILENAME" ]; then
        mv ${NEWFILE_NAME} ${FILENAME}
        if [ "${VIM}" == true ]; then
            vim ${FILENAME}
        fi
    fi
}

main "$@"
