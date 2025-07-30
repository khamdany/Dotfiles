#!/bin/bash

# --- Configuration ---
LOW_BATTERY_THRESHOLD=95
BATTERY_PATH="/org/freedesktop/UPower/devices/battery_BAT0"
LED_STATE_FILE="/usr/bin/scripts/.led_state"
LED_CONTROL_FILE="/proc/acpi/ibm/led"
NOTIFICATION_TIMEOUT=5000 # Notification stays on screen for 5 seconds

# --- Environment Setup ---
USER_NAME=$(who | awk 'NR==1{print $1}')
USER_ID=$(id -u "$USER_NAME")
DBUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"


# --- Script Logic ---
if ! UPowerInfo=$(upower -i "$BATTERY_PATH"); then
    exit 0
fi

percentage=$(echo "$UPowerInfo" | grep -m 1 'percentage:' | awk '{print $2}' | sed 's/%//')
state=$(echo "$UPowerInfo" | grep -m 1 'state:' | awk '{print $2}')

set_led_state() {
    if [ -w "$LED_CONTROL_FILE" ]; then
        echo "0 $1" | sudo tee "$LED_CONTROL_FILE" > /dev/null
    fi
}

# --- Main Decision Logic ---
# Check for the one specific condition: battery is low AND it's discharging.
if (( percentage < LOW_BATTERY_THRESHOLD )) && [[ $state == "discharging" ]]; then
    # --- Condition MET: Low and Discharging ---
    # Send a notification.
    sudo -u "$USER_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDRESS" dunstify -t "$NOTIFICATION_TIMEOUT" -u critical "Battery" "Remaining ${percentage}%"
    # Set the LED to blink.
    set_led_state "blink"
else
    # --- Condition NOT MET: All other cases (charging, full, or not low) ---
    # The LED's state will now be determined by the .led_state file.
    if [[ -f "$LED_STATE_FILE" && $(cat "$LED_STATE_FILE") == "1" ]]; then
        # If file exists and contains "1", turn LED on.
        set_led_state "on"
    else
        # Otherwise (file contains "0" or doesn't exist), turn LED off.
        set_led_state "off"
    fi
fi
