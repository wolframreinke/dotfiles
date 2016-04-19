#! /usr/bin/env bash


SCRIPT_PATH=${HOME}/scripts/globalColorscheme

dirty_changes ()
{
    echo "Unsaved changes: ${1}" >&2
    export HAS_CHANGED=true
}

files ()
{
    export XRESOURCES=".Xresources_${1}"
    export VIMRC=".vimrc_${1}"
    export TMUXCONF=".tmux.conf_${1}"
}

has_changed () { diff "${1}" "${2}" > /dev/null 2>&1 || dirty_changes "${2}"; }

if [ "${1}" == "dark" -o "${1}" == "light" ]; then

    if [ -e "${SCRIPT_PATH}/current_scheme" ]; then
        CURRENT=$(cat ${SCRIPT_PATH}/current_scheme)
        if [ "${CURRENT}" == "dark" -o "${CURRENT}" == "light" ]; then
            files "${CURRENT}"

            # make sure no changes are lost
            HAS_CHANGED=false
            has_changed ${SCRIPT_PATH}/${XRESOURCES} ${HOME}/.Xresources
            has_changed ${SCRIPT_PATH}/${VIMRC}      ${HOME}/.vimrc
            has_changed ${SCRIPT_PATH}/${TMUXCONF}   ${HOME}/.tmux.conf
            [ "${HAS_CHANGED}" == true ] && exit 1
        else
            echo "Current color scheme '${CURRENT}' doesn't exist." >&2
            exit 1
        fi
    fi

    files "${1}"
    cp ${SCRIPT_PATH}/${XRESOURCES} ${HOME}/.Xresources
    cp ${SCRIPT_PATH}/${VIMRC}      ${HOME}/.vimrc
    cp ${SCRIPT_PATH}/${TMUXCONF}   ${HOME}/.tmux.conf
    xrdb -load ${HOME}/.Xresources

    echo "${1}" > ${SCRIPT_PATH}/current_scheme
    echo "Done. Restart XTerm to see effects."
    exit 0
else

    echo "No such coloscheme.  Only 'light' and 'dark' exist."
fi
