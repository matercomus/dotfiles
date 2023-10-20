# Log errors of xinitrc
exec > ~/.xsession-errors 2>&1 &
set -x &

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

# run dwm blocks (statusbar)
dwmblocks &

# Set up monitors
/home/matt/.scripts/choose_monitor_layout.sh &

# set wallpapers
nitrogen --restore &

# run DWM
exec dwm

