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

SMILEY="${FG_COLOR_GREEN_DARK}:)${FG_COLOR_BLUE}"
STRAIGHTY="${FG_COLOR_GREEN_DARK}:|${FG_COLOR_BLUE}"
FROWNEY="${FG_COLOR_RED_DARK}:(${FG_COLOR_BLUE}"
CTRLCY="${FG_COLOR_BLUE_DARK}:P${FG_COLOR_BLUE}"
NOEXECY="${FG_COLOR_BLUE_DARK}:/${FG_COLOR_BLUE}"

case $1 in

      0)  echo "$SMILEY";;
    126)  echo "$NOEXECY";;
    127)  echo "$STRAIGHTY";;
    130)  echo "$CTRLCY";;
      *)  echo "$FROWNEY";;
esac

unsource_colors
