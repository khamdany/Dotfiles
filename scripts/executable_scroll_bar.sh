#!/bin/bash
FILE="$HOME/scripts/.scroll_lock_state"

ENABLED=●
DISABLED=◌

if [ -f "$FILE" ]; then
    num=$(cat "$FILE")
else
    num=0
fi

if [ $num -eq 1 ]; then
	echo $ENABLED
else
	echo $DISABLED
fi
