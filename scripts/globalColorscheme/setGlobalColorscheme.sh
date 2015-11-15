#! /usr/bin/env bash

if [ "${1}" == "light" ]; then

    cp ${HOME}/scripts/globalColorscheme/.Xresources_light ${HOME}/.Xresources
    cp ${HOME}/scripts/globalColorscheme/.vimrc_light ${HOME}/.vimrc
    cp ${HOME}/scripts/globalColorscheme/.tmux.conf_light ${HOME}/.tmux.conf
    xrdb -load .Xresources
    echo "Done. Restart XTerm to see effects."

elif [ "${1}" == "dark" ]; then

    cp ${HOME}/scripts/globalColorscheme/.Xresources_dark ${HOME}/.Xresources
    cp ${HOME}/scripts/globalColorscheme/.vimrc_dark ${HOME}/.vimrc
    cp ${HOME}/scripts/globalColorscheme/.tmux.conf_dark ${HOME}/.tmux.conf
    xrdb -load .Xresources
    echo "Done. Restart XTerm to see effects."

else

    echo "No such colorscheme, only 'light' and 'dark' exist."
fi
