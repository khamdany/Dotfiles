#!/bin/bash

# 1. 'ps -e -o comm=' lists only the executable names (no headers)
# 2. 'sort -u' removes duplicates so you see 'chrome' only once
# 3. 'fzf' lets you pick the name
program_name=$(ps -e -o comm= | sort -u | fzf --header "Select a Program Name to KILL ALL instances")

if [ -n "$program_name" ]; then
    echo "Killing all processes named: $program_name"
    
    # -x matches the process name exactly
    # -9 forces the kill
    pkill -9 -x "$program_name"
else
    echo "No program selected."
fi
