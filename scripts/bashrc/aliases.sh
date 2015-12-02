#! /bin/bash

# This script defines custom aliases

function _open {
    gnome-open ${1} > /dev/null 2>&1
}

function _import {
    source ${HOME}/scripts/lib/${1}
}

function _resource {
    for ALIAS in $(alias | grep -Po '(?<=alias ).*?(?=\=)'); do
        unalias ${ALIAS}
    done

    source ${HOME}/.bashrc
}

function forgiving_cd {
    builtin cd ${@} > ~/tmp/cd.tmp 2>&1
    if [ $? != 0 ]; then
        matches=($(ls -Ad */ | grep "^${1}"))
        if [ "${#matches[@]}" == 1 ]; then
            builtin cd ${matches[0]}
        else
            cat ~/tmp/cd.tmp >&2
            return 1
        fi
    fi
}

function xcd {
    forgiving_cd ${2} && ${1}
}

function xkcd {
    forgiving_cd ${3} && ${1} && ${2}
}

function _clear_and_l {
    source ${HOME}/scripts/lib/colors.sh
    clear
    echo -e "${FG_COLOR_CYAN}$(pwd)${FG_COLOR_RESET}"
    ls -l --color --group-directories-first | tail -n +2
    unsource_colors
}

function githubclone {
    path=${1}
    if [ "${2}" ]; then
        path=${path}/${2}
    fi
    git clone https://github.com/${path}
}

# Custom Aliases
alias c='_clear_and_l'
alias cls=clear

alias cd=forgiving_cd
alias cd..='builtin cd ..'
alias ..='builtin cd ..'
alias ...='builtin cd ../..'
alias ....='builtin cd ../../..'

alias l='ls -l --color=auto --group-directories-first'
alias la='ls -lA --color=auto --group-directories-first'
alias lsd='ls -ld --group-directories-first'

# cd aliases
alias cl='xcd "ls --color=auto --group-directories-first"'
alias cl..='cl ..'

alias cll='xcd "_clear_and_l"'
alias cll..='cll ..'

alias cla='xcd "ls -lA --color=auto --group-directories-first"'
alias cla..='cla ..'

alias +='pushd .'
alias _='popd'

alias resource='_resource'           # unaliases everything and sources .bashrc
alias open='_open'                   # opens with a suitable GUI program
alias fuck='sudo $(history -p \!\!)' # reruns the previous command with sudo

alias ghci='${HOME}/scripts/ghci_colored.sh /usr/bin/ghci'
alias redshift='$(cat $HOME/data/notes/redshift) > /dev/null 2>&1 &'
alias tree='tree -CFAla'
# alias which='slwhich'
alias github='githubclone'

alias session='snip with sessions'