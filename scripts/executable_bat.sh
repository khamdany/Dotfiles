#!/bin/bash

# Get the battery percentage from upower
bat0=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | rg -o 'percentage:\s+(\d+)%' --replace '$1')

# Check if the battery percentage is below 20
if (( bat0 < 20 )); then
    # Display a notification
    dunstify Battery "Remaining $bat0%" 
    
    # Get the current battery state (charging or discharging)
    state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -oP 'state:\s+\K\w+')

    # Path to the file storing LED state
    FILE="$HOME/scripts/.led_state"
    
    # Check if the state is charging and LED is enabled in the file
    if [[ $state == "charging" ]]; then
        if [[ $(cat "$FILE") == "1" ]]; then
            # Turn LED on if the file state is "1"
            echo "0 on" | sudo tee /proc/acpi/ibm/led 1> /dev/null
            echo "10 on" | sudo tee /proc/acpi/ibm/led 1> /dev/null
        else
            # Turn LED off if the file state is not "1"
            echo "0 off" | sudo tee /proc/acpi/ibm/led 1> /dev/null
            echo "10 off" | sudo tee /proc/acpi/ibm/led 1> /dev/null
        fi
    else
        # Blink LED if not charging
        echo "0 blink" | sudo tee /proc/acpi/ibm/led 1> /dev/null
        echo "10 blink" | sudo tee /proc/acpi/ibm/led 1> /dev/null
    fi
else 
    # You can add actions for when battery is above 20% if needed
    echo ''
    # Uncomment below to turn on LED when battery is above 20%
    # echo "0 on" | sudo tee /proc/acpi/ibm/led 1> /dev/null
    # echo "10 on" | sudo tee /proc/acpi/ibm/led 1> /dev/null
fi
