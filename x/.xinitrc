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

dwmblocks &
# polybar -r &


# set some java stuff
export AWT_TOOLKIT=MToolkit
export JDK_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
wmname compiz &

clipmenud &

setxkbmap pl &

sudo nm-applet &

blueman-applet &

# For QT Themes
# export QT_QPA_PLATFORMTHEME=qt5ct

# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# keyring stuff bc of vscode issue
export $(dbus-launch) &

# Set up monitors
xrandr --output eDP1 --mode 1920x1080 --pos 0x1600 --rotate normal --output DP1 --off --output DP1-1 --primary --mode 2560x1600 --pos 0x0 --rotate normal --output DP1-2 --mode 1920x1080 --pos 2560x0 --rotate normal --output DP2 --off --output VIRTUAL1 --off
# set wallpapers
nitrogen --restore &

exec dwm

