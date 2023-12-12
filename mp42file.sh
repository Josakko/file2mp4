#!/bin/bash


BLOCK_SIZE=16
FRAME_WIDTH=$(echo "${FRAME_WIDTH}/${BLOCK_SIZE}" | bc)
FRAME_HEIGHT=$(echo "${FRAME_HEIGHT}/${BLOCK_SIZE}" | bc)
MP4_HZ=60
MP4_FPS=60


if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input mo4 file> <output file>"
    exit 1
fi


input="$1"
output="$2"


ffmpeg -y -i "$input" -r ${MP4_FPS} -f rawvideo -pix_fmt monob -vf "scale=iw/${BLOCK_SIZE}:ih/${BLOCK_SIZE}" -video_size ${FRAME_WIDTH}x${FRAME_HEIGHT} -sws_flags neighbor -r ${MP4_HZ} pipe:1 | xz -d --stdout > "$output"
