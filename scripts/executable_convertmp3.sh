
#!/bin/bash

# Directory containing the files
dir="$HOME/Music/test"

# Loop over all files in the directory
for file in "$dir"/*
do
  # Get the base name of the file
  base=$(basename "$file")
  # Remove the extension from the base name
  name="${base%.*}"
  # Add '1' before '.mp3' to the new file name
  new_name="${name}1.mp3"
  # Use ffmpeg to convert the file to MP3 format
  ffmpeg -i "$file" -codec:a libmp3lame -b:a 320k "$new_name"
done
