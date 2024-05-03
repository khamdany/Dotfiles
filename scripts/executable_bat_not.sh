#!/bin/bash

bat0=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -oP 'percentage:\s+\K\d+')
bat1=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -oP 'percentage:\s+\K\d+')

average=$(echo "($bat0 + $bat1) / 2" | bc)

dunstify "Battery" "$average%"
