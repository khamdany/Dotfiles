ip=$(ip route | awk '/default/ { print $3 }')

sshfs -o allow_other -o port=2222 ssh@$ip:/ $HOME/Phone
