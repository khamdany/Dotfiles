#!/bin/bash

# Cek apakah wf-recorder sedang berjalan
if pgrep -x "wf-recorder" > /dev/null; then
    echo "Menghentikan perekaman..."
    pkill --signal SIGINT wf-recorder
else
    echo "Memulai perekaman dengan codec ringan (MKV) dan audio sinkron..."
    wf-recorder --audio=pipewire:alsa_output.pci-0000_00_1f.3.analog-stereo.monitor \
        -c libx264 -p crf=30 -p preset=ultrafast -p tune=film \
        -p vsync=2 -r 30 -f "$(xdg-user-dir VIDEOS)/$(date +'recording_%Y-%m-%d-%H%M%S.mp4')"
fi
