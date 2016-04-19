#! /usr/bin/env bash
#
# Colored output for GHCi, the haskell interpreter.  This script just makes
# error messages red, success messages green, and so on.  There are some
# problems, though.  Sometimes, GHCi's output is not displayed correctly, and I
# don't know exactly why.

source $HOME/scripts/lib/colors.sh

# -----------------------------------------------------------------------------
# Changes the foreground color of a string.
# Arguments:
#   (1) the string you wish to color
#   (2) the name of a color, which will be used as a variable name.  If you
#       give to this function the name "X", then the color code will be
#       FG_COLOR_X.
#
# Example:
#   >>> fgcolored "This is a red string" RED
function fgcolored {
    colorname="FG_COLOR_${2}"
    echo -e ${!colorname}${1}${FG_COLOR_RESET}
}


# -----------------------------------------------------------------------------
# Returns a sed substitution command, that, when applied to a string, replaces
# every occurence of a string with a colored version thereof.
# Arguments:
#   (1) a regular expression, in sed syntax
#   (2) a color code
#   (3) [optional] a string that is put in front of the substituted string,
#                  without color.
#   (4) [optional] a string that is appended to the substituted string, without
#                  color
#
# Example:
#   >>> colorpattern '[1-9]+' ${FG_COLOR_RED}
function colorpattern {
    echo "s/${1}/${3}$(fgcolored '&' ${2})${4}/g;"
}


# -----------------------------------------------------------------------------
# Combinator to build up sed patterns.  Applies the following sed patterns to
# all strings that match a certain pattern.
# Arguments:
#   (1) a sed pattern
#   (2) a number of sed substitution patterns
#
# Example:
#   >>> with '0x[1-9]+' "s/1/2/g s/4/5/g"
function with {
    echo "/${1}/ { ${2} }"
}
