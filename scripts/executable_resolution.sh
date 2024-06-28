#! /bin/bash


var=$1

if [[ $var == 1080 ]]
then
echo "output eDP-1 Resolution 1920x1080 " > ~/.config/sway/me/output
elif [[ $var == 720 ]] 
then
echo "output eDP-1 mode --custom 1280x720" >  ~/.config/sway/me/output 
elif [[ $var == 576 ]]
then
echo "output eDP-1 mode --custom 1024x576" >  ~/.config/sway/me/output
fi

echo "current: "
cat ~/.config/sway/me/output

if [[ $# -eq 0 ]]; then
    echo "    option:
    1080: 1920x1080
    720: 1280x720
    576: 1024x576"
    exit 1
fi
