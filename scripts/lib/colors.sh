#! /bin/bash
#===============================================================================
#
# (2014) by Wolfram Reinke
#
# This file contains definitions for colors which are usable in a bash script.
# Source this file to access the constants.
#
#===============================================================================

#-------------------------------------------------------------------------------
# FOREGROUND COLORS
#-------------------------------------------------------------------------------
export FG_COLOR_BLACK='\033[0;30m'
export FG_COLOR_GRAY_DARK='\033[1;30m'
export FG_COLOR_RED_DARK='\033[0;31m'
export FG_COLOR_RED='\033[1;31m'
export FG_COLOR_GREEN_DARK='\033[0;32m'
export FG_COLOR_GREEN='\033[1;32m'
export FG_COLOR_YELLOW_DARK='\033[0;33m'
export FG_COLOR_BROWN=$FG_COLOR_YELLOW_DARK
export FG_COLOR_YELLOW='\033[1;33m'
export FG_COLOR_BLUE_DARK='\033[0;34m'
export FG_COLOR_BLUE='\033[1;34m'
export FG_COLOR_PURPLE_DARK='\033[0;35m'
export FG_COLOR_VIOLET_DARK=$FG_COLOR_PURPLE_DARK
export FG_COLOR_PURPLE='\033[1;35m'
export FG_COLOR_VIOLET=$FG_COLOR_PURPLE
export FG_COLOR_CYAN_DARK='\033[0;36m'
export FG_COLOR_TURQUOISE_DARK=$FG_COLOR_CYAN_DARK
export FG_COLOR_CYAN='\033[1;36m'
export FG_COLOR_TURQUOISE=$FG_COLOR_CYAN
export FG_COLOR_GRAY='\033[0;37m'
export FG_COLOR_WHITE='\033[1;37m'
export FG_COLOR_RESET='\033[0m'

#-------------------------------------------------------------------------------
# BACKGROUND COLORS
#-------------------------------------------------------------------------------
export BG_COLOR_BLACK='\033[40m'
export BG_COLOR_RED_DARK='\033[41m'
export BG_COLOR_GREEN_DARK='\033[42m'
export BG_COLOR_YELLOW_DARK='\033[43m'
export BG_COLOR_BROWN=$BG_COLOR_YELLOW_DARK
export BG_COLOR_BLUE_DARK='\033[44m'
export BG_COLOR_MAGENTA_DARK='\033[45m'
export BG_COLOR_CYAN_DARK='\033[46m'
export BG_COLOR_GRAY='\033[47m'
export BG_COLOR_GRAY_DARK='\033[100m'
export BG_COLOR_RED='\033[101m'
export BG_COLOR_GREEN='\033[102m'
export BG_COLOR_YELLOW='\033[103m'
export BG_COLOR_BLUE='\033[104m'
export BG_COLOR_MAGENTA='\033[105m'
export BG_COLOR_CYAN='\033[106m'
export BG_COLOR_WHITE='\033[107m'
export BG_COLOR_GREEN='\033[42m'
export BG_COLOR_RESET='\033[49m'


function unsource_colors {
    unset FG_COLOR_BLACK
    unset FG_COLOR_GRAY_DARK
    unset FG_COLOR_RED_DARK
    unset FG_COLOR_RED
    unset FG_COLOR_GREEN_DARK
    unset FG_COLOR_GREEN
    unset FG_COLOR_YELLOW_DARK
    unset FG_COLOR_BROWN
    unset FG_COLOR_YELLOW
    unset FG_COLOR_BLUE_DARK
    unset FG_COLOR_BLUE
    unset FG_COLOR_PURPLE_DARK
    unset FG_COLOR_VIOLET_DARK
    unset FG_COLOR_PURPLE
    unset FG_COLOR_VIOLET
    unset FG_COLOR_CYAN_DARK
    unset FG_COLOR_TURQUOISE_DARK
    unset FG_COLOR_CYAN
    unset FG_COLOR_TURQUOISE
    unset FG_COLOR_GRAY
    unset FG_COLOR_WHITE
    unset FG_COLOR_RESET

    unset BG_COLOR_BLACK
    unset BG_COLOR_RED_DARK
    unset BG_COLOR_GREEN_DARK
    unset BG_COLOR_YELLOW_DARK
    unset BG_COLOR_BROWN
    unset BG_COLOR_BLUE_DARK
    unset BG_COLOR_MAGENTA_DARK
    unset BG_COLOR_CYAN_DARK
    unset BG_COLOR_GRAY
    unset BG_COLOR_GRAY_DARK
    unset BG_COLOR_RED
    unset BG_COLOR_GREEN
    unset BG_COLOR_YELLOW
    unset BG_COLOR_BLUE
    unset BG_COLOR_MAGENTA
    unset BG_COLOR_CYAN
    unset BG_COLOR_WHITE
    unset BG_COLOR_GREEN
    unset BG_COLOR_RESET
}

function showcase_colors {
    echo "Foreground Colors"
    echo -e "\t ${FG_COLOR_BLACK}fg_color_black${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_GRAY_DARK}fg_color_gray_dark${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_RED_DARK}fg_color_red_dark${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_RED}fg_color_red${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_GREEN_DARK}fg_color_green_dark${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_GREEN}fg_color_green${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_YELLOW_DARK}fg_color_yellow_dark${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_BROWN}fg_color_brown${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_YELLOW}fg_color_yellow${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_BLUE_DARK}fg_color_blue_dark${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_BLUE}fg_color_blue${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_PURPLE_DARK}fg_color_purple_dark${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_VIOLET_DARK}fg_color_violet_dark${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_PURPLE}fg_color_purple${FG_COLOR_RESET}"
    echo -e "\t ${FG_lib}fg_color_violet${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_VIOLET}fg_color_violet${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_CYAN_DARK}fg_color_cyan_dark${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_TURQUOISE_DARK}fg_color_turquoise_dark${FG_COLOR_REST}"
    echo -e "\t ${FG_COLOR_CYAN}fg_color_cyan${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_TURQUOISE}fg_color_turquoise${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_GRAY}fg_color_gray${FG_COLOR_RESET}"
    echo -e "\t ${FG_COLOR_WHITE}fg_color_white${FG_COLOR_RESET}"

    echo "Background Colors"
    echo -e "\t ${BG_COLOR_BLACK}bg_color_black${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_RED_DARK}bg_color_red_dark${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_GREEN_DARK}bg_color_green_dark${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_YELLOW_DARK}bg_color_yellow_dark${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_BROWN}bg_color_brown${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_BLUE_DARK}bg_color_blue_dark${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_MAGENTA_DARK}bg_color_magenta_dark${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_CYAN_DARK}bg_color_cyan_dark${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_GRAY}bg_color_gray${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_GRAY_DARK}bg_color_gray_dark${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_RED}bg_color_red${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_GREEN}bg_color_green${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_YELLOW}bg_color_yellow${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_BLUE}bg_color_blue${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_MAGENTA}bg_color_magenta${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_CYAN}bg_color_cyan${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_WHITE}bg_color_white${BG_COLOR_RESET}"
    echo -e "\t ${BG_COLOR_GREEN}bg_color_green${BG_COLOR_RESET}"
}
