#!/bin/sh
xrandr --output eDP1 --mode 1920x1080 --pos 0x1200 --rotate normal --output DP1 --off --output DP2 --off --output DP2-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output DP2-2 --off --output VIRTUAL1 --off &
xrandr --output eDP1 --mode 1920x1080 --pos 0x1200 --rotate normal --output DP1 --off --output DP2 --off --output DP2-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output DP2-2 --off --output VIRTUAL1 --off &
nitrogren --restore
