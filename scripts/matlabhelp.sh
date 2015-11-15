#! /bin/bash
#
# Documentation: see usage below

echo "Caution! I uninstalled MATLAB, so searchin the matlab help is not going \
      to help you.  To use this script again, update the matlab search path   \
      in this file." | tr -s " " | fold -w 80 -s
exit 0

if [ "$1" ]; then

    if [ "$1" == "-h" ]; then
        echo -e
            "Usage: $0 <keyword>\n                                             \
             Searches in your current directory and in the Matlab help to find \
             a function, class or file that contains the given keyword.  All   \
             lines of this file up to the first non-blank line are displayed   \
             after removing the leading '%'." | tr -s " " | fold -w 80 -s
    else
        PROJECT_PATH=$PWD
        SEARCH_PATH=/opt/matlab/toolbox

        # Matches from the current project are preferred to matches from the
        # Matlab help, so that the user can shadow existing functions

        projectMatches=$(find $PROJECT_PATH -name *$1*.m)
        if [ "$projectMatches" ]; then

            match=$(echo $projectMatches | tr " " "\n" | head -1)
            sed -e '/^$/,$d' "$match" | grep '^%' | cut -c 2- | less
        else

            matlabMatches=$(find $SEARCH_PATH -name *$1*.m)
            if [ "$matlabMatches" ]; then

                match=$(echo $matlabMatches | tr " " "\n" | head -1)
                sed -e '/^$/,$d' "$match"   \
                    | grep '^%'             \
                    | cut -c 2-             \
                    | less
            else
                echo "(No results)" | less
            fi
        fi
    fi
fi
