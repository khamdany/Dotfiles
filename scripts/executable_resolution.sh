#!/usr/bin/env bash
set -euo pipefail

OUTPUT="eDP-1"

# Ambil JSON dari swaymsg
json=$(swaymsg -t get_outputs)

# Buat array modes dalam format WIDTHxHEIGHT@REFHz
mapfile -t modes < <(
  jq -r --arg out "$OUTPUT" '
    .[] 
    | select(.name == $out) 
    | .modes[] 
    | "\(.width)x\(.height)@\(.refresh/1000|floor)Hz"
  ' <<< "$json"
)

# Ambil mode saat ini
current_mode=$(jq -r --arg out "$OUTPUT" '
  .[] 
  | select(.name == $out) 
  | "\(.current_mode.width)x\(.current_mode.height)@\(.current_mode.refresh/1000|floor)Hz"
' <<< "$json")

# Pastikan ada mode yang ditemukan
if (( ${#modes[@]} == 0 )); then
  echo "Error: Tidak ada mode ditemukan untuk output $OUTPUT." >&2
  exit 1
fi

# Cari indeks mode saat ini
current_index=-1
for i in "${!modes[@]}"; do
  if [[ "${modes[i]}" == "$current_mode" ]]; then
    current_index=$i
    break
  fi
done

if (( current_index < 0 )); then
  echo "Error: Mode saat ini ($current_mode) tidak ditemukan dalam daftar." >&2
  exit 1
fi

# Hitung indeks mode berikutnya (wrap-around)
next_index=$(( (current_index + 1) % ${#modes[@]} ))
next_mode=${modes[next_index]}

# Terapkan mode berikutnya
printf "Mengganti mode: %s → %s\n" "$current_mode" "$next_mode"
swaymsg output "$OUTPUT" mode "$next_mode" >/dev/null 2>&1

# Aktifkan adaptive sync
swaymsg output "$OUTPUT" adaptive_sync on >/dev/null 2>&1 || {
  echo "Peringatan: Gagal mengaktifkan adaptive sync pada $OUTPUT" >&2
}
