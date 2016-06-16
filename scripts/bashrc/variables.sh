#! /bin/bash

# This file defines custom environment variables

# Only add my custom stuff to the path once.  Without this guard, the path would
# be extended every time, I start a new tmux-split.
if [ -z "${PATH_CUSTOMIZATIONS}" ]; then

    # Higher priority than the default components
    export PATH="$HOME/bin:$PATH"                 # the bin dir in $HOME
    export PATH=".:$PATH"                         # the current path

    # lower priority than the default components
    export PATH="$PATH:/opt/java/jdk1.8.0_45/bin" # all the java stuff
    export PATH="$PATH:$HOME/.cabal/bin"          # stuff installed via cabal
    export PATH="$PATH:$HOME/data/programFiles/dasht/bin"

    export MANPATH="$MANPATH:$HOME/scripts/manpages"

    export PATH_CUSTOMIZATIONS=true
fi

export JAVA_HOME="/opt/java/jdk1.8.0_45/jre"
export EDITOR=vim
