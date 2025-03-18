#!/bin/bash
### Script that opens a workspace tmux session and reattaches to it

# Variables
w="workspace2"

if tmux has-session -t "$w" 2>/dev/null; then
    if ! tmux list-sessions -F '#{session_name}: #{session_attached}' | grep -q "^$w: 1"; then
        alacritty -e tmux a -t "$w" & exit
    fi
else
    # Open new session if it doesnt exist
    alacritty -e tmux new-session -s "$w"
fi
