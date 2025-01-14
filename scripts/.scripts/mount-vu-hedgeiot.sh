#!/usr/bin/env bash

# Function to display usage message
usage() {
    echo "Usage: $0 <username> [-l <local_path>] [-r <remote_path>]"
    exit 1
}

# Check if at least 1 argument is provided
if [ "$#" -lt 1 ]; then
    usage
fi

# Check if sshfs is installed
if ! command -v sshfs >/dev/null 2>&1; then
    echo "Error: sshfs is not installed. Please install it first."
    exit 1
fi

USERNAME=$1
shift

# Default values
SERVER_IP=130.37.53.67
LOCAL_PATH=~/vu-hedgeiot-server
REMOTE_PATH=/home/${USERNAME}/

# Parse optional flags
while getopts "l:r:" opt; do
    case ${opt} in
        l)
            LOCAL_PATH=$OPTARG
            ;;
        r)
            REMOTE_PATH=$OPTARG
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

# Perform the SSHFS mount
sshfs -o reconnect \
      -o cache=yes \
      -o kernel_cache \
      -o ServerAliveInterval=15 \
      -o ServerAliveCountMax=3 \
      -o ProxyJump=${USERNAME}@ssh.data.vu.nl \
      ${USERNAME}@${SERVER_IP}:${REMOTE_PATH} \
      ${LOCAL_PATH}

if [ $? -eq 0 ]; then
    echo "Mounted ${USERNAME}@${SERVER_IP}:${REMOTE_PATH} to ${LOCAL_PATH}"
else
    echo "Failed to mount!"
    exit 1
fi

