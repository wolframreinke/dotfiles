#! /usr/bin/env bash
#
# Colored output for GHCi, the haskell interpreter.  This script just makes
# error messages red, success messages green, and so on.  There are some
# problems, though.  Sometimes, GHCi's output is not displayed correctly, and I
# don't know exactly why.


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

function main {

    # variable names for color codes
    source ${HOME}/scripts/lib/colors.sh

    # If no argument is given, the default ghci binary is used, otherwise,
    # the argument is used instead.
    if [ "${1}" ]; then
        app_name=${1}
        shift
    else
        app_name=/usr/bin/ghci
        echo "using /usr/bin/ghci"
    fi

    # Color rules for type signatures.  Everything that follows a '::' is
    # colored according to these rules.
    pattern_signatures=$(with '::.*'                \
        "$(colorpattern '->' BLUE_DARK) \
         $(colorpattern '=>' BLUE_DARK) \
         $(colorpattern '::' BLUE_DARK) \
         $(colorpattern '~'  BLUE_DARK) \
         $(colorpattern '('  BLUE_DARK) \
         $(colorpattern ')'  BLUE_DARK) \
        ")

    # Runs the application and applies all sed-rules to its outputs
    ${app_name} "${@}" 2>&1 | \
      sed "$(colorpattern '^Failed, modules loaded:'        RED_DARK)   \
           $(colorpattern '^Ok, modules loaded:'            GREEN_DARK) \
           $(colorpattern '^\*\*\*.*'                       RED_DARK)   \
           $(colorpattern 'In the expression:'              GREEN)      \
           $(colorpattern 'In an expression type signature' GREEN)      \
           $(colorpattern 'In an equation'                  GREEN)      \
           $(colorpattern 'In the first argument'           GREEN)      \
           $(colorpattern 'In the second argument'          GREEN)      \
           $(colorpattern 'In the third argument'           GREEN)      \
           $(colorpattern 'Perhaps you meant'               GREEN)      \
           $(colorpattern 'Warning'                         BROWN)      \
           $(colorpattern '‘[^’]*’'                         BLUE_DARK)  \
           $(colorpattern '^[^:]*:[0-9]*:[0-9]*:'           RED_DARK)   \
           ${pattern_signatures}                                        \
          "

    # Make sure, color variables don't pollute the executing shell.
    unsource_colors
}

# Only run the main function, if this script is executed from a subshell, that
# is, not sourced.
if [[ $_ == $0 ]]; then
    main $@
fi
