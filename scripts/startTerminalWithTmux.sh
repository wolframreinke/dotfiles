#!/usr/bin/env bash
# Starts a new xterm which attaches to the "base" tmux-session.  If this session
# doesn't yet exist, it's created.
#
# This is used to start xterm and tmux automatically together without doing
# something risky as modifying bashrc accordingly.

exec xterm -T "TMUX in XTerm" \
           -n "TMUX in XTERM" \
           -e "tmux attach -t base || tmux new -s base"
