#! /usr/bin/env bash


SCRIPT_PATH=${HOME}/scripts/globalColorscheme


if [ "${1}" == "dark" -o "${1}" == "light" ]; then

    XRESOURCES=".Xresources_${1}"
    VIMRC=".vimrc_${1}"
    TMUXCONF=".tmux.conf_${1}"
    ln -sf $(readlink -f "${SCRIPT_PATH}/${XRESOURCES}") "${HOME}/.Xresources"
    ln -sf $(readlink -f "${SCRIPT_PATH}/${VIMRC}")      "${HOME}/.vimrc"
    ln -sf $(readlink -f "${SCRIPT_PATH}/${TMUXCONF}")   "${HOME}/.tmux.conf"
    xrdb -load ${HOME}/.Xresources

    echo "Done. Restart XTerm to see effects."
else
    echo "No such color scheme.  Only 'light' and 'dark' exist."
    exit 1
fi
