#!/bin/bash

LOGFILE="/tmp/bt_debug.log"
echo "Script started at $(date)" >> "$LOGFILE"

udevadm monitor --subsystem-match=bluetooth | while read line; do
    echo "Event detected: $line" >> "$LOGFILE"

    if echo "$line" | grep -q "remove.*hci0:256"; then
        echo "Bluetooth removed - Pausing media" >> "$LOGFILE"
        playerctl pause
    elif echo "$line" | grep -q "add.*hci0:256"; then
        echo "Bluetooth added - Resuming media" >> "$LOGFILE"
        playerctl play
    fi
done
