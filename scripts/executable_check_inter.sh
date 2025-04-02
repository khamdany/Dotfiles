ping 8.8.8.8 > $HOME/scripts/.ping.txt &
# ping 127.0.0.1> ping.txt &


while tail $HOME/scripts/.tail.txt && sleep 5
 do
  tail=$(tail -n 1 $HOME/scripts/.ping.txt)
  connect=$(tail -n 1 $HOME/scripts/.ping.txt | rg ttl)
  if [[ "$connect" == "" ]]; then
    connect=ttl
  fi
  if [[ "$tail" == "$connect" ]]; then
    dunstify "Internet" "connected"
  fi
done

