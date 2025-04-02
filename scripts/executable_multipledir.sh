#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <directory_pattern> <command>"
    exit 1
fi

# Iterate over subdirectories matching the specified pattern
for D in $1; do
    if [ -d "$D" ]; then
        # Execute the provided command for each subdirectory
        eval "$2 \"$D\""
    fi
done
