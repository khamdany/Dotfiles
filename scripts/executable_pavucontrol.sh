
#!/bin/bash 

pid=`pgrep pavucontrol`
status=$?

if [ $status != 0 ] 
then 
  pavucontrol
else 
  pkill --signal SIGINT pavucontrol
fi;
