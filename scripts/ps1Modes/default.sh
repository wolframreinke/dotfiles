#! /bin/bash

# imports custom color definitions to make the prompt more beautiful
. ~/scripts/lib/colors.sh

export PS1="\\[${FG_COLOR_GREEN}\\]\u@\h\\[${FG_COLOR_BLUE}\\] \W \\[${FG_COLOR_RESET}\\]\\[${FG_COLOR_RESET}\\]$ "

# all those environment variables pollute the bash. This function removes them
unsource_colors
