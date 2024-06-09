#!/bin/bash

# Check if the folder "kdefilesd" exists
if [ "$HOME/kdefilesd" ]; then
    rm -r "$HOME/kdefilesd"
fi

userdir='/run/user/1000'
results=$(ls /run/user/1000/ | grep -E '^.{31}' | grep -v keepass)
# Create a symbolic link to the specified directory
ln -s "$userdir/$results/storage/3925-1B12/" "$HOME/kdefilesd"
echo "Sdcard Connected"
cd $HOME/kdefilesd
