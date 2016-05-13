#!/usr/bin/env bash
#
# This script creates symlinks for all dotfiles and directories in this
# repository.  The location where the symlinks are put is determined by the
# first command arg.  If no args are given, the symlinks are put into the
# user's home directory.

if [ "$1" ]; then
    target="$1"
else
    target=${HOME}
fi

echo -n "Caution!  This script is out-of-date, you will have to manually       \
         install .vimrc, .tmux.conf and .Xresources, since the most recent     \
         versions of these files now reside in scripts/globalColorscheme."     \
         | tr -s " " | fold -s -w 80

echo -e "\n\ninstalling to: ${target}"
echo -n "Existing install files in the target directory will be deleted. Are \
         you sure, you wish to continue? (y/n) " | tr -s " " | fold -s -w 80
read response

if [ "${response}" == "y" ]; then

    echo -n "Making sure that target directory exists... "
    mkdir -p ${target} > /dev/null 2>&1
    echo "Done."

    for file in $(ls -A); do
        if [ ${file} != ".git" ]; then
            target_file=${target}/${file}

            echo -n "Creating symlink: ${target_file}... "
            rm -rf ${target_file} > /dev/null 2>&1
            ln -s $(readlink -f ${file}) ${target_file}
            echo "Done."
        fi
    done

    # Delete install script
    rm ${target}/${0}

    echo "Success!"
else
    echo "Aborting."
    exit
fi
