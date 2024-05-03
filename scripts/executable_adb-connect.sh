#!/bin/bash

# Extract IP address related to wlan0
ip_address=$(ip route | grep 'wlan0' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

# Connect adb to the extracted IP address
adb connect "$ip_address"

