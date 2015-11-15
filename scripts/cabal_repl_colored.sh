#! /bin/bash
#
# Colors the output of the "cabal repl" command, by using the ghci_colored
# script.  This script can be used as an alias for the "cabal" command.  If
# repl is given as the first argument, then the colored version is executed,
# every other argument is just routed to the cabal binary.

if [ "${1}" == "repl" ]; then
    /usr/local/bin/cabal ${@}

    # doesn't work, do nothing....
    # ${HOME}/scripts/ghci_colored.sh "/usr/local/bin/cabal repl"
else
    /usr/local/bin/cabal ${@}
fi

