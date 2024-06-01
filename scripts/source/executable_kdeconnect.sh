
#!/bin/bash

userdir='/run/user/1000'
results=$(ls /run/user/1000/ | grep -E '^.{31}' | grep -v keepass)
echo $results
cd $userdir/$results/storage/emulated/0
