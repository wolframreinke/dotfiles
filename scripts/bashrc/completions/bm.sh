#! /bin/bash

function debug {
    [ ${DEBUG} == true ] && echo "[DEBUG] $1"
}

# [TAB]-Completion for the Bookmarking script
# The first component of the path typed by the user is completed by using the
# list of known bookmark names, the rest by using the files at the bookmarked
# location. For example, if the user types "bm ha[TAB]", this will be completed
# to "bm haskell", since "haskell" is the name of a bookmark. However, if one
# types "bm haskell/t[TAB]", then this will be completed to "bm haskell/tmp",
# if there is a file or dir called "tmp" at the location "haskell" refers to.
function _complete_bm
{
    DEBUG=false

    debug ""

    # The location where all bookmarking files are stored
    local BMPATH=${HOME}/scripts/bookmarks

    # The input, the user has typed so far and which we want to complete.
    local CURRENT=${COMP_WORDS[COMP_CWORD]}

    # The first path component of the word-to-complete is the bookmark's name
    local BOOKMARK=$(echo ${CURRENT} | cut -d/ -f1)

    debug "bmpath = $BMPATH"
    debug "current = $CURRENT"
    debug "bookmark = $BOOKMARK"

    # If the word-to-complete is a path (i.e. contains a "/" char), then
    # everything behind the bookmark's name is part of the relative path from
    # this bookmark's location. Basically, we've split the input at the first /
    # so haskell/tmp/misc becomes haskell in BOOKMARK and tmp/misc in USERPATH.
    if [[ ${CURRENT} == */* ]]; then
        local USERPATH=$(echo ${CURRENT} | cut -d/ -f2-)
    else
        local USERPATH="(none)"     # Just a bookmark without path
    fi

    debug "userpath = $USERPATH"

    if [ ! "${USERPATH}" == "(none)" ]; then

        # If we have a path behind the bookmark name and the referenced
        # bookmark actually exists, then we can try to complete by using the
        # files and directories at the bookmarked location
        if [    -e "${BMPATH}/permanent/${BOOKMARK}.bm" \
             -o -e "${BMPATH}/temporary/${BOOKMARK}.bm" ]; then

            # If the word-to-complete ended in "/" (like e.g. "asm/"), then the
            # USERPATH is empty (does not even contain "(none)". In that case,
            # we cannot complete anything and just return a list of the files
            # at the bookmarked location
            if [ -z "${USERPATH}" ]; then

                # USERPATH is empty, but we still have to add the / at the end
                # of the path
                debug "showing list of possible completions..."
                DIR=$(bm -p ${BOOKMARK})/
                COMPREPLY=($(compgen -W "$(ls ${DIR} 2> /dev/null)" -- ""))

            elif [[ "${USERPATH}" == */ ]]; then

                # If USERPATH ends in / but is not empty, then we have to
                # append the user path to the bookmarked path and display all
                # the contained files.
                debug "showing list of possible completions..."
                DIR=$(bm -p ${BOOKMARK})/${USERPATH}
                COMPREPLY=($(compgen -W "$(ls ${DIR} 2> /dev/null)" -- ""))

            else

                # Here comes the tricky part. If the USERPATH is incomplete, we
                # need to complete it by using the list of files in this
                # directory. However, compgen only checks whether the word-
                # to-complete is a prefix of any of the completion
                # possibilities and replaces it, if there is only one match.
                #
                # Alas, this will replace the bookmark+path the user already
                # typed with the name of the directory without any relative or
                # absolute path, so haskell/tmp/mi[TAB] will just become
                # "misc".
                #
                # Therefore, we actually use absolute paths and later replace
                # the first portion of the absolute path with the bookmark
                # name, so that we have a path relative to the bookmarked
                # location.  Watch closely.

                debug "showing completions..."

                # Retrieves the absolute path to the bookmarked location
                BMTARGET=$(bm -p ${BOOKMARK})

                # Computes the length of this part to replace it later
                BMTLEN=$(echo ${BMTARGET} | wc -c)

                # Bookmark path + the rest of the word-to-complete
                # Now we have basically expanded the bookmark's name with its
                # actual value, so haskell/tmp has become
                # /home/tungsten/programming/lang/haskell/tmp
                DIR=${BMTARGET}/${USERPATH}

                # The uncompleted portion of the path is removed to retrieve the
                # base directory, whose contained files are the completion
                # candidates
                BASEDIR=$(dirname ${DIR})

                # Generates the list of possiblilties. The "nl" tool is used to
                # prepend the BASEDIR to each of the entries, yielding a list of
                # absolute paths to the directory contents. "nl" also adds line
                # numbers, which we remove by using "cut"
                POSS=$( ls ${BASEDIR} 2> /dev/null  \
                      | nl -s ${BASEDIR}/           \
                      | cut -c7-)

                # Finally, we use this list of possibilities to complete the
                # word. We don't want to replace everything the user typed with
                # the absolute path, so we remove the absolute path prefix
                # (whose length we computed in BMTLEN) and prepend the name
                # of the bookmark to make everything look normal again.
                COMPREPLY=($(compgen -W "${POSS}" -- ${DIR}             \
                            | cut -c${BMTLEN}-                          \
                            | nl -s ${BOOKMARK}                         \
                            | cut -c7-))

                debug "possibilities = ${POSS}"
                debug "basedir = $BASEDIR"
                debug "dir = $DIR"
                debug "compreply = $COMPREPLY"
            fi
        fi
    else
        # No path was specified behind the bookmark's name, therefore only
        # bookmark names are completed, not files at the bookmarked path
        BMS=$({ ls ${BMPATH}/permanent | grep -Po '.*?(?=\.bm)';   \
                ls ${BMPATH}/temporary | grep -Po '.*?(?=\.bm)'; } \
              | sed -e 's/$/\//')
        BMS_ALT=$(echo "$BMS" | sed -e 's/$/.../')
        COMPREPLY=( $(compgen -W "${BMS} ${BMS_ALT}" -- ${CURRENT}) )
        debug "bms = $BMS"
        debug "bms_alt = $BMS_ALT"
        debug "compreply = $COMPREPLY"
    fi
}

complete -F _complete_bm bm
