#! /bin/bash

function checkPython {
    python -m py_compile $@
    rm -rf *.pyc
}

function checkC++ {
    g++ $@ -Wall -Werror && echo "Done."
}

function checkC {
    echo $@
    gcc -S $@ -Wall -Werror && echo "Done."
}

function checkSh {
    bash -n $@
}

function checkHaskell {
    ghc --make $@ -Wall && echo "Done."
}

while :; do
    if [ -e "$1" ]; then
        inotifywait -rqe close_write $1
        clear
        $2
    else
        echo "Couldn't watch '$1' - No such file or directory" >&2
        exit 1
    fi
done
