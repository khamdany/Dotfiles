#!/bin/bash

# Function to find kitty PID with child htop process
function find_kitty_htop_pid() {
  kitty_pids=$(pgrep kitty)
  for kitty_pid in $kitty_pids; do
    # Check if kitty has child htop using ps
    if ps --ppid "$kitty_pid" | grep -q htop; then
      echo "$kitty_pid"  # return the first kitty PID with child htop
      return 0  # Exit the function with success (0)
    fi
  done
  return 1  # Exit the function with failure (1)
}

# Find kitty with htop (check all instances)
launchedKittyPid=$(find_kitty_htop_pid)
if [[ $? -eq 0 ]]; then
  echo "Launched kitty with htop (PID: $launchedKittyPid)"
else
  echo "No kitty process found with htop. Launching kitty with htop..."
  kitty htop &  # Launch kitty with htop in the background
  # Re-run find_kitty_htop_pid to get the newly launched process PID
  launchedKittyPid=$(find_kitty_htop_pid)
  if [[ $? -eq 0 ]]; then
    echo "Successfully launched kitty with htop (PID: $launchedKittyPid)"
  else
    echo "Failed to launch kitty with htop process"
    exit 1  # Exit with error code if launch failed
  fi
fi

# Kill kitty process when script exits
kill "$launchedKittyPid"
echo "Killed kitty (PID: $launchedKittyPid)"
