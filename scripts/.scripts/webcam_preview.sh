#!/bin/bash

# This script is used to preview the webcam video stream

# Send a notification
notify-send "Webcam Preview" "Starting webcam preview..."

ffplay -f v4l2 -input_format mjpeg -framerate 30 -video_size 1920x1080 /dev/video0
