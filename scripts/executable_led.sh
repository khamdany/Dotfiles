#!/bin/bash
FILE="$HOME/scripts/.led_state"

# Check if the state file exists and read its value, otherwise default to 0
if [ -f "$FILE" ]; then
    num=$(cat "$FILE")
else
    num=0
fi

# Toggle the scroll lock and update the state
if [ $num -eq 0 ]; then
    echo "0 on" | sudo tee /proc/acpi/ibm/led > /dev/null    
    echo "10 on" | sudo tee /proc/acpi/ibm/led > /dev/null 
    echo 1 > "$FILE"
else
    echo "0 off" | sudo tee /proc/acpi/ibm/led > /dev/null    
    echo "10 off" | sudo tee /proc/acpi/ibm/led > /dev/null 
    echo 0 > "$FILE"
fi
