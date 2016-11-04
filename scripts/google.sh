#! /bin/bash
#
# opens firefox to display google results.

urlencode() {
    local string="${@}"
    local strlen=${#string}
    local encoded=""
    local pos c o


    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] ) o="${c}";;
            * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done

    echo ${encoded}
}

query="$(urlencode ${@})"
url="https://www.google.com/search?q=${query}&gws_rd=ssl"

if [ -z "${DISPLAY}" ]; then
    w3m ${url}
else
    firefox ${url} &  > /dev/null 2>&1
fi
