#!/usr/bin/env bash
#
# Creates a symlink in ~/bin pointing to the file you pass in as a parameter.
# If the file has the extension "sh", then this extension is removed.  For
# example, "binlink.sh" becomes "binlink".

if [ -e "${1}" ]; then

    if [ "${2}" ]; then
        filename="${2}"
    else
        filename=$(basename "${1}")

        extension="${filename##*.}"
        if [ "${extension}" == "sh" ]; then
            filename="${filename%.*}"
        fi
    fi

    echo -e "link name:\t${filename}"
    echo -e "file name:\t$(readlink -f ${1})"
    ln -s $(readlink -f ${1}) ${HOME}/bin/${filename}
    echo "Done."
else
    echo "File name required" >&2
    exit 1
fi
