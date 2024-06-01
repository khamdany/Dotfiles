
#!/bin/bash 

pid=`pgrep wf-recorder`
status=$?

if [ $status != 0 ] 
then 
  wf-recorder -p crf=20 -p preset=medium -p tune=film --audio=pipewire -f $(xdg-user-dir VIDEOS)/$(date +'recording_%Y-%m-%d-%H%M%S.mp4');
else 
  pkill --signal SIGINT wf-recorder
fi;
