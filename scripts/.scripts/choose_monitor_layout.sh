#!/bin/bash

# Detect the number of connected monitors
monitor_count=$(xrandr -q | grep " connected" | wc -l)

# Choose the appropriate screen layout script based on the number of connected monitors
if [ $monitor_count -eq 3 ]; then
    # 2 external monitors + built in laptop display
    echo "Using 2 external monitors"
    /home/matt/.screenlayout/2Mon.sh
else
    # Just the laptop display
    echo "Using only laptop display"
    /home/matt/.screenlayout/laptop_only.sh
fi

