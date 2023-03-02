# start compositor
DISPLAY=":0" picom -b &

# setup sound
sleep 1
/usr/bin/pipewire &
sleep 1
/usr/bin/pipewire-pulse &
sleep 1
/usr/bin/wireplumber &

# launch notofication deamon
twmnd &

# run dwm blocks (statusbar)
dwmblocks &

# set window manager name
wmname compiz &

# run clipmenu deamon
clipmenud &

# set keyboard layout to PL
setxkbmap pl &

# run network manager applet
sudo nm-applet &

# run blueman applet
blueman-applet &

# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# keyring stuff bc of vscode issue
export $(dbus-launch) &

# Set up monitors
xrandr --output eDP1 --off --output DP1 --off --output DP2 --off --output DP2-1 --mode 2560x1600 --pos 0x0 --rotate normal --output DP2-2 --mode 1920x1080 --pos 2560x260 --rotate normal --output VIRTUAL1 --off

# set wallpapers
nitrogen --restore &

# run DWM
exec dwm

