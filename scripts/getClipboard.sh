#!/usr/bin/env bash
#
# Reads the contents of the primary clipboard by using VIM

rm ~/tmp/clip.txt > /dev/null 2>&1
vim -c "call feedkeys('i*:wq')" ~/tmp/clip.txt > /dev/null 2>&1
cat ~/tmp/clip.txt
