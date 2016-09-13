#! /bin/bash

# imports custom color definitions to make the prompt more beautiful
. $HOME/scripts/lib/colors.sh

SMILEY="${FG_COLOR_GREEN_DARK}:)${FG_COLOR_BLUE}"
STRAIGHTY="${FG_COLOR_GREEN_DARK}:|${FG_COLOR_BLUE}"
FROWNEY="${FG_COLOR_RED_DARK}:(${FG_COLOR_BLUE}"
# FACE='[ $? -eq 0 ] && echo -e "$SMILEY" || echo -e "$FROWNEY"'

FACE='echo -e $($HOME/scripts/ps1Modes/getSmiley.sh $?)'

export PS1="\\[${FG_COLOR_GREEN}\\]\u\\[${FG_COLOR_RESET}\\] \$($FACE) \\[${FG_COLOR_YELLOW}\\]\W\\[${FG_COLOR_RESET}\\] (\$(date +%R))> "

# all those environment variables pollute the bash. This function removes them
unsource_colors
