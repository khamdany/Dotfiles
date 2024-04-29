#!/bin/bash

# Use command substitution to get the process ID of iwgtk
pgrep_result=$(pgrep htop)

if [ -z "$pgrep_result" ]; then
    # If iwgtk is not running, start it
    exec htop 
else
    # If iwgtk is already running, kill it
    kill "$pgrep_result"
fi
