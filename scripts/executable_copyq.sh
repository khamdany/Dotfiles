#!/bin/bash
FILE="$HOME/scripts/.copyq_state"

# Check if the state file exists and read its value, otherwise default to 0
if [ -f "$FILE" ]; then
    num=$(cat "$FILE")
else
    num=0
fi

# Toggle the scroll lock and update the state
if [ $num -eq 0 ]; then
    copyq --start-server show
    echo 1 > "$FILE"
else
    copyq --start-server hide
    echo 0 > "$FILE"
fi

