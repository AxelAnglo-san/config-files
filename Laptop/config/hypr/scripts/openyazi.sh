#!/bin/bash
### Script to manage yazi in separate tmux sessions

# Variables
yz="yz"

# If there is a session attach to it
if tmux has-session -t "$yz" 2>/dev/null; then
    if ! tmux list-sessions -F '#{session_name}: #{session_attached}' | grep -q "^$yz: 1"; then
        alacritty -e tmux a -t "$yz" & exit
    fi
else
    # Open new session if it doesnt exist
    alacritty -e tmux new-session -s "$yz" \; send-keys "yazi" C-m & exit
fi

