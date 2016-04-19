#! /usr/bin/env bash
#
# Colored output for GHCi, the haskell interpreter.  This script just makes
# error messages red, success messages green, and so on.  There are some
# problems, though.  Sometimes, GHCi's output is not displayed correctly, and I
# don't know exactly why.


function main {

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
}

if [ "$_" == "$0" ]; then
    source $HOME/scripts/lib/sedpatterns.sh

    main $@
fi
