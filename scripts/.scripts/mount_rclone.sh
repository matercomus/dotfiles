#!/usr/bin/env bash

# Function to display usage message
usage() {
    echo "Usage: $0 <username> [-l <local_path>] [-r <remote_path>] [-n <rclone_remote_name>]"
    echo
    echo "  <username>             Your username on the remote server"
    echo "  -l <local_path>        Local mount point (default: ~/vu-hedgeiot-server)"
    echo "  -r <remote_path>       Remote path to mount (default: /home/<username>/ )"
    echo "  -n <rclone_remote_name>Name of the rclone remote in your config (default: hedgeiot)"
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
LOCAL_PATH=~/vu-hedgeiot-server
REMOTE_PATH=/home/${USERNAME}/
RCLONE_REMOTE=hedgeiot   # The remote name in rclone config

# Parse optional flags
while getopts "l:r:n:" opt; do
    case ${opt} in
        l)
            LOCAL_PATH=$OPTARG
            ;;
        r)
            REMOTE_PATH=$OPTARG
            ;;
        n)
            RCLONE_REMOTE=$OPTARG
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

# Mount the remote via rclone
# --vfs-cache-mode writes: ensures partial writes are cached locally before uploading
# --daemon (Linux/macOS): run in background so you don't block the terminal
rclone mount \
    "${RCLONE_REMOTE}:${REMOTE_PATH}" \
    "${LOCAL_PATH}" \
    --vfs-cache-mode writes \
    --daemon

# Check exit code
if [ $? -eq 0 ]; then
    echo "Mounted ${RCLONE_REMOTE}:${REMOTE_PATH} -> ${LOCAL_PATH}"
    echo "You can now edit remote files locally in ${LOCAL_PATH}"
else
    echo "Failed to mount!"
    exit 1
fi
