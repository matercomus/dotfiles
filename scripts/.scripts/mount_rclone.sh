#!/usr/bin/env bash

# Function to display usage message
usage() {
    echo "Usage: $0 <username> [-l <local_path>] [-r <remote_path>] [-n <rclone_remote_name>] [-v]"
    echo
    echo "  <username>             Your username on the remote server"
    echo "  -l <local_path>        Local mount point (default: ~/<rclone_remote_name>-remote)"
    echo "  -r <remote_path>       Remote path to mount (default: /home/<username>/ )"
    echo "  -n <rclone_remote_name>Name of the rclone remote in your config (default: hedgeiot)"
    echo "  -v                     Verbose mode. Prints the final rclone command."
    exit 1
}

# Check if at least 1 argument is provided (the username)
if [ "$#" -lt 1 ]; then
    usage
fi

# Check if rclone is installed
if ! command -v rclone >/dev/null 2>&1; then
    echo "Error: rclone is not installed. Please install it first."
    exit 1
fi

USERNAME=$1
shift

# Default values
RCLONE_REMOTE=hedgeiot   # The remote name in rclone config
LOCAL_PATH=~/${RCLONE_REMOTE}-remote
REMOTE_PATH=/home/${USERNAME}/
VERBOSE=0

# Parse optional flags
while getopts "l:r:n:v" opt; do
    case ${opt} in
        l)
            LOCAL_PATH=$OPTARG
            ;;
        r)
            REMOTE_PATH=$OPTARG
            ;;
        n)
            RCLONE_REMOTE=$OPTARG
            LOCAL_PATH=~/${RCLONE_REMOTE}-remote
            ;;
        v)
            VERBOSE=1
            ;;
        \?)
            usage
            ;;
    esac
done

# Create local path if it doesn't exist
if [ ! -d "$LOCAL_PATH" ]; then
    mkdir -p "$LOCAL_PATH"
fi

# Construct the rclone command
RCLONE_CMD="rclone mount ${RCLONE_REMOTE}:${REMOTE_PATH} ${LOCAL_PATH} --vfs-cache-mode writes --daemon"

# Print the rclone command if verbose mode is enabled
if [ $VERBOSE -eq 1 ]; then
    echo "Running command: $RCLONE_CMD"
fi

# Execute the rclone command
$RCLONE_CMD

# Check exit code
if [ $? -eq 0 ]; then
    echo "Mounted ${RCLONE_REMOTE}:${REMOTE_PATH} -> ${LOCAL_PATH}"
    echo "You can now edit remote files locally in ${LOCAL_PATH}"
else
    echo "Failed to mount!"
    exit 1
fi
