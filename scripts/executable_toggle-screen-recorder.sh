#!/bin/bash

# Function to start recording using appropriate encoder
start_recording() {
    # Set the output path using the VIDEOS directory and date-time format
    output_path="$(xdg-user-dir VIDEOS)/$(date +'recording_%Y-%m-%d-%H%M%S.mp4')"
    
    # Check if an NVIDIA GPU is available
    if command -v nvidia-smi &> /dev/null; then
        encoder="hevc_nvenc"
        # HEVC NVENC menggunakan 'qp' juga. We use 'nv12' as the intermediate format for GPU.
        additional_params="-p preset=fast -p qp=28"
        # Use the 'scale' filter to force a GPU-friendly format (nv12) before encoding
        FILTER_PARAM="-p filter=scale=out_color_matrix=bt709:format=nv12"
        echo "Menggunakan NVIDIA NVENC dengan encoder: $encoder"
    else
        encoder="libx265"
        # Use 'yuv420p' as the intermediate format for CPU encoding
        additional_params="-p crf=28 -p preset=medium -p tune=ssim"
        FILTER_PARAM="-p filter=format=yuv420p"
        echo "Menggunakan encoder CPU: $encoder"
    fi

    # The wf-recorder call now includes the FILTER_PARAM determined above
    wf-recorder --audio=pipewire:alsa_output.pci-0000_00_1f.3.analog-stereo.monitor \
        -c "$encoder" $additional_params \
        $FILTER_PARAM \
        -p vsync=2 -r 60 -f "$output_path"
}

# Check if wf-recorder is running
if pgrep -x "wf-recorder" > /dev/null; then
    echo "Menghentikan perekaman..."
    pkill --signal SIGINT wf-recorder
else
    echo "Memulai perekaman dengan codec HEVC (x265) dan audio sinkron..."
    start_recording
fi
