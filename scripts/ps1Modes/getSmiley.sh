#! /bin/bash
# ----------------------------------------------------------------------------
# File    : getSmiley.sh.sh
# Author  : Wolfram Reinke
# Created : 06/19/15
# ----------------------------------------------------------------------------
#
# Add a description here
#
# ----------------------------------------------------------------------------

source $HOME/scripts/lib/colors.sh

SMILEY=":)"
STRAIGHTY=":|"
FROWNEY=":("
CTRLCY=":P"
NOEXECY=":/"

case $1 in

      0)  echo "$SMILEY";;
    126)  echo "$NOEXECY";;
    127)  echo "$STRAIGHTY";;
    130)  echo "$CTRLCY";;
      *)  echo "$FROWNEY";;
esac

unsource_colors
