#! /bin/bash
#
# opens firefox to display google results.

while [ $# -ne 0 ]
do
    firefox "https://www.google.com/search?q=$1&gws_rd=ssl" & > /dev/null 2>&1
    shift
done
