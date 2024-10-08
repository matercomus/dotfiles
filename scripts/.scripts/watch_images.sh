#!/bin/bash

# Check if the directory argument is provided
if [ -z "$1" ]; then
	echo "Usage: $0 /path/to/your/images"
	exit 1
fi

# Directory to monitor
IMAGE_DIR="$1"
FIFO="/tmp/nsxiv_fifo"

# Ensure the FIFO does not already exist
[ -e "$FIFO" ] && rm "$FIFO"

# Create a FIFO for nsxiv
mkfifo "$FIFO"

# Function to find the latest image and display it with nsxiv
show_latest_image() {
	LATEST_IMAGE=$(ls -t "$IMAGE_DIR"/*.{jpg,jpeg,png,gif} 2>/dev/null | head -n 1)
	if [ -n "$LATEST_IMAGE" ]; then
		echo "$LATEST_IMAGE" >"$FIFO"
	fi
}

# Find the initial image
INITIAL_IMAGE=$(ls -t "$IMAGE_DIR"/*.{jpg,jpeg,png,gif} 2>/dev/null | head -n 1)

if [ -n "$INITIAL_IMAGE" ]; then
	# Start nsxiv in background with the initial image
	nsxiv -f -N "nsxiv_image_viewer" "$INITIAL_IMAGE" <"$FIFO" &
else
	# Start nsxiv in background without images
	nsxiv -f -N "nsxiv_image_viewer" "$FIFO" &
fi

# Monitor the directory for new images and display the latest one
inotifywait -m -e create "$IMAGE_DIR" --format "%f" --exclude '.*\.(tmp|swp|~)$' | while read NEW_FILE; do
	show_latest_image
done

# Clean up
rm "$FIFO"
