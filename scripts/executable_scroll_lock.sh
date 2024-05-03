#!/bin/bash
FILE="$HOME/scripts/.scroll_lock_state"
DEVICE="2:10:TPPS/2_IBM_TrackPoint"

# Check if the state file exists and read its value, otherwise default to 0
if [ -f "$FILE" ]; then
    num=$(cat "$FILE")
else
    num=0
fi

# Toggle the scroll lock and update the state
if [ $num -eq 0 ]; then
    swaymsg input "$DEVICE" scroll_button_lock enabled
    echo 1 > "$FILE"
else
    swaymsg input "$DEVICE" scroll_button_lock disabled
    echo 0 > "$FILE"
fi
