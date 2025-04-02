#!/bin/bash

# Define menu options without a leading newline
options="󰞷 Reload Sway
󰍃 Logout
 Lock
 Sleep
 Restart
 Shutdown"

# Show menu with Rofi (enabling icons)
selection=$(echo "$options" | rofi -dmenu -p "Power Menu" -markup-rows -show-icons)

# Execute the corresponding command
case "$selection" in
    "󰞷 Reload Sway")
        swaymsg reload
        ;;
    "󰍃 Logout")
        swaymsg exit
        ;;
    " Lock")
        swaylock -f -i "$HOME/Pictures/images_dark/1920x1080.png" --fingerprint -c 111111
        ;;
    " Sleep")
        systemctl suspend
        ;;
    " Restart")
        systemctl reboot
        ;;
    " Shutdown")
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
