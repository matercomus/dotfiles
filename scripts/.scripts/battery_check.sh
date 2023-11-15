#!/bin/bash

# Define the battery level at which to send a warning
LOW_BATTERY_THRESHOLD=20
FULL_BATTERY_THRESHOLD=100

while true; do
    # Get the current battery level
    BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
    # Get the current battery status
    BATTERY_STATUS=$(cat /sys/class/power_supply/BAT0/status)

    if (( BATTERY_LEVEL < LOW_BATTERY_THRESHOLD )) && [[ "$BATTERY_STATUS" == "Discharging" ]]; then
        # Send a low battery notification
        notify-send "Low Battery" "Your battery is at ${BATTERY_LEVEL}%, please plug in your charger."
    elif (( BATTERY_LEVEL == FULL_BATTERY_THRESHOLD )) && [[ "$BATTERY_STATUS" == "Charging" ]]; then
        # Send a full battery notification
        notify-send "Battery Full" "Your battery is fully charged, you can unplug your charger."
    fi

    # Sleep for 5 minutes
    sleep 300
done
