#! /bin/bash


if [[ $# -eq 0 ]]; then
    echo "use app_id or class"
    exit 1
fi

var=$1

echo "for_window [app_id=\"${var}\"] floating enable" >> ~/.local/share/chezmoi/dot_config/sway/me/window
