#! /bin/bash

# $1 is target pane
# $2 is command

tmux capture-pane -t $1 -S -32768
tmux save-buffer ~/tmp/tmuxcapture
tmux delete-buffer
tmux send-keys -t $1 "$2" Enter
sleep 0.25
tmux capture-pane -t $1 -S -32768
tmux save-buffer ~/tmp/tmuxcapture2
tmux delete-buffer
let diff=$(cat ~/tmp/tmuxcapture2 | wc -l)-$(cat ~/tmp/tmuxcapture | wc -l)
cat ~/tmp/tmuxcapture2 | tail -n $diff | head -n -1
