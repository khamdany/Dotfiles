#!/bin/bash

# Get the battery percentage for bat0 (first battery)
bat0=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -oP 'percentage:\s+\K\d+')

# Display the battery percentage using dunstify
dunstify "Battery" "$bat0%"
