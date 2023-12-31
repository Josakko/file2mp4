#!/bin/bash


if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input file> <output mp4 file>"
    exit 1
fi

input="$1"
output="$2"

BLOCK_SIZE=16
FRAME_WIDTH_MP4=1920
FRAME_HEIGHT_MP4=1080

FRAME_WIDTH=$(echo "${FRAME_WIDTH_MP4}/${BLOCK_SIZE}" | bc)
FRAME_HEIGHT=$(echo "${FRAME_HEIGHT_MP4}/${BLOCK_SIZE}" | bc)
MP4_HZ=60
MP4_FPS=60

#FILE_SIZE=$(stat -c%s "$input")

NEXT_SIZE=$(echo "($FRAME_WIDTH*$FRAME_HEIGHT)" | bc)

{ xz -1 -k "$input" --stdout; dd if=/dev/zero bs=$NEXT_SIZE count=1; } | ffmpeg -y -f rawvideo -pix_fmt monob -video_size ${FRAME_WIDTH}x${FRAME_HEIGHT} -r ${MP4_HZ} -i "pipe:0" -vf scale=iw*${BLOCK_SIZE}:ih*${BLOCK_SIZE} -sws_flags neighbor -r ${MP4_FPS} -pix_fmt yuv420p -preset superfast "$output"
