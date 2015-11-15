#! /bin/bash

# all files listed below are sourced during the creation of a new
# bash. It is referenced from directly from .bashrc

source $HOME/scripts/bashrc/completions.sh
source $HOME/scripts/bashrc/variables.sh
source $HOME/scripts/bashrc/aliases.sh
source $HOME/scripts/bashrc/miscellaneous.sh

# Bookmarking script needs ability to change the directory. Therefore it was
# converted to a shell function, which is called via an alias.
source $HOME/scripts/bookmarks/bm.sh

# Custom PS1 prompt
source $HOME/scripts/ps1Modes/smileys.sh
