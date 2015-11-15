# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
        . /etc/bash.bashrc
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ ! "$TERM" == "linux" ]; then
    export TERM='screen-256color'
fi

function alert {
    if [ ! -z "${1}" ]; then
        summary="${1}"
    else
        summry="(untitled)"
    fi

    notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "${summary}"
}

source $HOME/scripts/bashrc/sourceList.sh

# clear the ~/tmp directory
rm -rf $HOME/tmp/*

# clear all temporary bookmarks
bm --cleartmp

# enables CTRL-S for vim (but disables the corresponding control flow feature)
stty -ixon

bind Space:magic-space
