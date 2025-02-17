#!/bin/bash

EXTENSION="hidetopbar@mathieu.bidon.ca"

# Check if the extension is enabled
if gnome-extensions list --enabled | grep -q "$EXTENSION"; then
    # Disable it (Always show top bar)
    gnome-extensions disable "$EXTENSION"
    notify-send "Top Bar" "Always visible mode enabled" -i preferences-system
else
    # Enable it (Show on hover)
    gnome-extensions enable "$EXTENSION"
    notify-send "Top Bar" "Auto-hide enabled (shows on hover)" -i preferences-system
fi

