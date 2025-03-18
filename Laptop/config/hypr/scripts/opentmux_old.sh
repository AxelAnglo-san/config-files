#!/bin/bash
## Open workspace for Hyprland keybind SUPER+Q
# This script is abel to check the existing tmux session names
# It then attaches to existing ones or creates new ones

# Variables
session_name="workspace"
session_number=1

# Debugging: Enable execution tracing
#set -x

# Checks if there is a kitty open
if pgrep -x "kitty" > /dev/null; then
    echo "Kitty is running. Checking tmux sessions..."

    # Loop for checking multiple options
    for ((i = 0; i <= 10; i++)); do

        # Checks if there is a tmux session with the set name
        tmux has-session -t ${session_name}${session_number} 2>/dev/null
        echo Checking session: ${session_name}${session_number}

        if [ $? == 0 ]; then

            # Create new kitty session with new tmux name
            ((session_number++))
            tmux has-session -t ${session_name}${session_number} 2>/dev/null

            if [ $? == 0 ]; then

                kitty -e tmux a -t ${session_name}${session_number} &
                echo Found ${session_name}${session_number} opening it..
                ((session_number++))
                continue

            elif [ $? == 1 ]; then

                echo "Creating new tmux session: ${session_name}${session_number}"
                kitty -e tmux new -s ${session_name}${session_number} &
                ((session_number++))

            fi

        elif [ $? == 1 ]; then

            # Check for different matches
            echo "Session ${session_name}${session_number} not found. Incrementing..."
            ((session_number++))

        fi
    done
echo Exiting..
    
# If there isnt check if there is a tmux session
else
    echo "Kitty is not running. Attaching or creating a tmux session..."

    # Loop for checking multiple options
    for ((i = 0; i <= 10; i++)); do

        # Checks if there is a tmux session with the set name
        tmux has-session -t ${session_name}${session_number} 2>/dev/null
        
        if [ $? = 0 ]; then
            # Attach to tmux session 
            echo "Attaching to tmux session: ${session_name}${session_number}"
            kitty -e tmux a -t ${session_name}${session_number} &
            ((session_name++))

        else 

            # Check for different matches
            echo "Session ${session_name}${session_number} not found. Incrementing..."
            ((session_number++))

            #if [ $i = 10 ]; then

            #    # Create new tmux session
            #    echo "Creating new tmux session: ${session_name}${session_number}"
            #    session_number=1
            #    kitty -e tmux new -s ${session_name}${session_number} &
            #    exit
            #fi
        fi
    done
fi
echo Exiting..
