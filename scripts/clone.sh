#!/usr/bin/env bash
#
# git clones from the URL in the clipboard
git clone $(xclip -selection clipboard -o)
