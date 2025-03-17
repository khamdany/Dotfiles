#!/bin/bash
current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'[/%]' '{print $2}' | tr -d ' ')

if (( current_volume > 120 )); then
    pactl set-sink-volume @DEFAULT_SINK@ 120%
fi
