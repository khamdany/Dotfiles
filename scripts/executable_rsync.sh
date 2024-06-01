#!/bin/bash

# Define the source and destination directories
source_dir="$HOME/Music/"
destination_dir="$HOME/Phone/Music"
# destination_dir="/run/user/1000/53271068_f8e5_4696_b460_e8e413dc26e6/storage/3925-1B12/Music"

normal1="$HOME/Music"
normal2="/run/user/1000/53271068_f8e5_4696_b460_e8e413dc26e6/storage/3925-1B12/Music"

# Run rsync in dry-run mode to get the list of files to be deleted and copied
raw=$(rsync -avun --delete --exclude='~Music/test/' $source_dir $destination_dir)

# Initialize a flag to indicate whether we are in the section of the output that lists the files to be copied
copying=false

if [[ "$1" == "comp" ]]; then
  # Process each line of the rsync output
  echo "$raw" | while read -r line
  do
    if [[ $line == deleting* ]]; then
      del="${line#deleting }"
      echo "Deleting: $destination_dir/$del"
      rm -r "$destination_dir/$del"
    fi

    # If the line starts with "./", then we are in the section of the output that lists the files to be copied
    if [[ $line == ./* ]]; then
      copying=true
    fi

    # Skip if the line represents a directory in the source directory
    if [[ -d "$normal1/$line" ]]; then
      continue
    fi

    # If the line starts with "sent", then we are past the section of the output that lists the files to be copied
    if [[ $line == sent* ]]; then
      copying=false
    fi

    # If we are in the section of the output that lists the files to be copied, then copy the file
    if $copying; then
      cp="${line#.}"
      echo "$normal1/$cp to $destination_dir/$cp"
      cp -r "$normal1/$cp" "$destination_dir/$cp"
    fi
  done
elif [[ "$1" == "android" ]]; then
  # rsync -avu --delete --exclude='~Music/test/' /run/user/1000/53271068_f8e5_4696_b460_e8e413dc26e6/storage/3925-1B12/Music/ "$HOME/Music"
  rsync -avu --delete --no-perms --exclude='~Music/test/' $HOME/Phone/Music/ "$HOME/Music"
else
  echo "Invalid argument. Usage: $0 [comp|android]"
fi
