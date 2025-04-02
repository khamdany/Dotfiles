#!/bin/bash

filenames=$(ls $HOME/.local/share/applications/ | grep waydroid)
location="$HOME/.local/share/applications"

marked_filenames=""
for app in $filenames; do
  if grep -q 'NoDisplay=true' "$location/$app"; then
    marked_filenames+="[*] $app\n"
  else
    marked_filenames+="$app\n"
  fi
done

sorted_apps=$(echo -e "$marked_filenames" | sort -t '*' -k 2)

sorted_apps=$(echo -e "$sorted_apps" | sed '/^$/d')

selected_apps=$(echo -e "$sorted_apps"  | fzf --multi)

for app in $selected_apps; do
  if [[ "$app" == "[*]" ]]; then
      continue
  fi
  
  if grep -q 'NoDisplay=true' "$location/$app"; then
    sed -i '/NoDisplay=true/d' "$location/$app"
    echo "[ ] Removed NoDisplay=true from $app"
  else
    sed -i '/\[Desktop Entry\]/a NoDisplay=true' "$location/$app"
    echo "[*] Added NoDisplay=true to $app"
  fi
done
