#!/bin/bash
## Open workspace for Hyprland keybind SUPER+Q
# This script is abel to check the existing tmux session names
# It then attaches to existing ones or creates new ones

# Variables
bn="workspace" # Base name
sn="workspace1" # Standard name
ld=20 # Loop durations

# Check if kitty is running
# If kitty is running
if pgrep -x "kitty" > /dev/null; then
    echo "Check tmux in kitty"

    tmux_ses_found=false
    for ((i = 1; i <= $ld; i++)); do
        lv="${bn}${i}"
        echo "i$i"
        if tmux has-session -t $lv 2>/dev/null; then
            echo "Found tmux ses $lv"
            tmux list-sessions -F '#{session_name}: #{session_attached}' | grep -q "^$lv: 1"
            if [ $? -eq 0 ]; then

                for ((j = i; j <= $ld; j++)); do
                    lv2="${bn}$((j+1))" # TODO
                    echo "j$j"  
                    tmux list-sessions -F '#{session_name}: #{session_attached}' | grep -q "^$lv2: 1"
                    if [ $? -eq 0 ]; then
                        echo "The next session is also attached. $lv2"

                    else
                        ((i += 2)) 
                        echo "i$i"
                        kitty -e tmux new -s $lv2 &
                        tmux_ses_found=true
                        echo "Open new, since its not attached to any $lv2"
                        exit

                    fi
                done
            elif [ $? -eq 0 ] && [ "$tmux_ses_found" = false ]; then
                ((i++))
                kitty -e tmux new -s $lv &
                tmux_ses_found=true
                echo "Open new $lv"

            else
                kitty -e tmux a -t $lv &
                tmux_ses_found=true
                echo "Open not attached $lv"

            fi

        else
            if [ $i = 1 ]; then
                kitty -e tmux new -s $lv &
                tmux_ses_found=true
                echo "Open new since no $lv"
                exit

            else
                echo "Its not $lv"

            fi
        fi

        if [ $i -eq 9 ] && [ "$tmux_ses_found" = false ]; then
            kitty -e tmux new -s $sn &
            echo "There isnt a tmux ses. Open $sn"

        fi
    done

# If kitty is not running
else
    echo "Kitty not running"

    ses_was_opened=false
    for ((i = 1; i <= $ld; i++)); do
        lv="${bn}${i}"

        if tmux has-session -t $lv; then
            kitty -e tmux a -t $lv &
            ses_was_opened=true
            echo "Open $lv"

        else
            echo "!Ses increment"

        fi

        if [ $i -eq 9 ] && [ "$ses_was_opened" = false ]; then
            kitty -e tmux new -s $sn &
            echo "No tmux ses found, opening $sn"

        fi         
    done
fi
