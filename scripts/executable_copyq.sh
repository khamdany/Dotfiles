#!/bin/bash
FILE="$HOME/scripts/.copyq_state"

# Read the current state from the file or default to 0 if the file doesn't exist.
read -r num < "$FILE" 2>/dev/null || num=0

# Determine the next state and corresponding CopyQ action.
if (( num == 0 )); then
    next=1
    action="show"
else
    next=0
    action="hide"
fi

# Execute the CopyQ command and update the state file.
copyq --start-server "$action"
echo "$next" > "$FILE"
