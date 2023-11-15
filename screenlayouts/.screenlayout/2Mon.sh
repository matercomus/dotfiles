#!/bin/sh
xrandr --output eDP1 --off --output DP1 --off --output DP1-1 --mode 3840x2160 --pos 0x0 --rotate normal --output DP1-2 --primary --mode 1920x1080 --pos 3840x489 --rotate normal --output DP2 --off --output VIRTUAL1 --off &&
  xrandr --output eDP1 --off --output DP1 --off --output DP1-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --output DP1-2 --mode 1920x1080 --pos 3840x489 --rotate normal --output DP2 --off --output VIRTUAL1 --off
