#!/bin/bash

# Get the current volume
current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F ' / ' '{print $2}' | cut -d '%' -f1)

# Check if the current volume is greater than 150%
if (( current_volume > 120 )); then
    # If so, set the volume to 120%
    pactl set-sink-volume @DEFAULT_SINK@ 120%
fi
