#!/bin/bash
### Script that opens yazi in seperate tmux ses and window
# It is able to do this whit up to two, and reattach to existing ones

# Variables
readonly yz="yz"
readonly yz2="yz2"

# Function that finds or creates the given variable
find_or_create_tmux() {
    local sg="$1" # Session given

    # If its not attached attach
    if tmux has-session -t "$sg" 2>/dev/null && ! tmux list-sessions -F '#{session_name}: #{session_attached}' | grep -q "^$sg: 1"; then
        alacritty -e tmux a -t "$sg" & 
        exit
    fi

    # If it doesnt exist create it
    if ! tmux has-session -t "$sg" ; then
        alacritty -e tmux new-session -s "$sg" \; send-keys "yazi" C-m & 
        exit 
    fi
}

# Function that attaches to not attached sessions
attach_if_able() {
    local sg="$1" # Session given

    if ! tmux list-sessions -F '#{session_name}: #{session_attached}' | grep -q "^$sg: 1"; then
        alacritty -e tmux a -t "$sg" & 
        exit  
    fi
}

# Function that opens both unattached sessions if able
attach_to_both_if_able() {
    if tmux has-session -t "$yz" 2>/dev/null && tmux has-session -t "$yz2" 2>/dev/null; then
        if ! tmux list-sessions -F '#{session_name}: #{session_attached}' | grep -q "^$yz: 1" && \
            ! tmux list-sessions -F '#{session_name}: #{session_attached}' | grep -q "^$yz2: 1"; then
            alacritty -e tmux a -t "$yz" &
            alacritty -e tmux a -t "$yz2" &
            exit
        fi
    fi
}

# Call a function to attach to both if able
attach_to_both_if_able

# Check if tmux session $yz exists
if tmux has-session -t "$yz" 2>/dev/null; then 
    attach_if_able "$yz"
    find_or_create_tmux "$yz2"
fi

# Check if tmux session $yz2 exists
if tmux has-session -t "$yz2" 2>/dev/null; then
    attach_if_able "$yz2"
    find_or_create_tmux "$yz"
fi

# If both session exist exit
if tmux has-session -t "$yz" 2>/dev/null && tmux has-session -t "$yz2" 2>/dev/null; then
    exit
fi

# If no session was open or exists open $yz
alacritty -e tmux new-session -s "$yz" \; send-keys "yazi" C-m & exit
