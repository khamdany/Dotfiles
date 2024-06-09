
#!/bin/bash

if [ "$HOME/kdefileintern" ]; then
    rm -r "$HOME/kdefileintern"
fi

userdir='/run/user/1000'
results=$(ls /run/user/1000/ | grep -E '^.{31}' | grep -v keepass)

ln -s "$userdir/$results/storage/emulated/0/" "$HOME/kdefileintern"
echo "Sdcard Connected"
cd $HOME/kdefileintern
