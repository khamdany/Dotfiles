im=$(qdbus "org.fcitx.Fcitx5" "/controller" "org.fcitx.Fcitx.Controller1.CurrentInputMethod")

if [ "$im" = "keyboard-us" ]; then
  state=1
elif [ "$im" = "mozc" ]; then
  state=2
elif [ "$im" = "m17n_ru_translit" ]; then
  state=3
elif [ "$im" = "pinyin" ]; then
  state=4
else
  state=1
fi

if [ $state -eq 4 ]; then
  state=1
else
  state=$((state + 1))
fi

if [ $state -eq 1 ]; then
  fcitx5-remote -s keyboard-us
elif [ $state -eq 2 ]; then
  fcitx5-remote -s mozc
elif [ $state -eq 3 ]; then
  fcitx5-remote -s m17n_ru_translit
elif [ $state -eq 4 ]; then
  fcitx5-remote -s pinyin
fi
im=$(qdbus "org.fcitx.Fcitx5" "/controller" "org.fcitx.Fcitx.Controller1.CurrentInputMethod")
dunstctl close-all
dunstify "Input Method" "$im"
