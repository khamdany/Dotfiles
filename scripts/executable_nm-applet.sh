#!/bin/bash

# Get the process ID(s) of iwgtk
pgrep_result=$(pgrep -x iwgtk)

if [ -z "$pgrep_result" ]; then
    echo "Starting iwgtk..."
    nohup iwgtk >/dev/null 2>&1 & disown
else
    echo "Stopping iwgtk..."
    kill "$pgrep_result"
fi
