#!/bin/bash

bat0=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg -o 'percentage:\s+(\d+)%' --replace '$1')
bat1=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | rg -o 'percentage:\s+(\d+)%' --replace '$1')

average=$(echo "($bat0 + $bat1) / 2" | bc)

FILE="$HOME/scripts/.led_state"
state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -oP 'state:\s+\K\w+')
# $average
# Check if below 20%
if (( $(echo "$average < 20" | bc -l) )); then
    dunstify Battery "Remaining $average%" 
    if [[ $state == "charging" ]]; then
       if [[$FILE == "1"]]; then
         echo "0 on" | sudo tee /proc/acpi/ibm/led 1> /dev/null
         echo "10 on" | sudo tee /proc/acpi/ibm/led 1> /dev/nulli
       else
         echo "0 off" | sudo tee /proc/acpi/ibm/led 1> /dev/null
         echo "10 off" | sudo tee /proc/acpi/ibm/led 1> /dev/nulli
       fi
    else
      echo "0 blink" | sudo tee /proc/acpi/ibm/led 1> /dev/null
      echo "10 blink" | sudo tee /proc/acpi/ibm/led 1> /dev/null
    fi
 else 
     echo ''
     # echo "0 on" | sudo tee /proc/acpi/ibm/led 1> /dev/null
     # echo "10 on" | sudo tee /proc/acpi/ibm/led 1> /dev/null
fi
