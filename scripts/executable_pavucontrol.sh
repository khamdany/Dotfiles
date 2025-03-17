#!/bin/bash

if pgrep pavucontrol > /dev/null; then
    pkill -KILL pavucontrol
else
    pavucontrol &
fi
