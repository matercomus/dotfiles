#!/usr/bin/env bash

usage() {
    echo "Usage: $0 <username> <host> [-l <local_path>] [-r <remote_path>] [-n <rclone_remote_name>] [-v]"
    echo
    echo "  <username>             Your username on the remote server"
    echo "  <host>                 The remote host as specified in rclone config"
    echo "  -l <local_path>        Local mount point (default: ~/vu-compute)"
    echo "  -r <remote_path>       Remote path to mount (default: /home/<username>/ )"
    echo "  -n <rclone_remote_name>Name of the rclone remote in your config (default: same as <host>)"
    echo "  -v                     Print the final rclone command"
    exit 1
}

if [ "$#" -lt 2 ]; then
    usage
fi

if ! command -v rclone >/dev/null 2>&1; then
    echo "Error: Install rclone first."
    exit 1
fi

USERNAME=$1
HOST=$2
shift 2

LOCAL_PATH=~/vu-compute
REMOTE_PATH="/home/${USERNAME}/"
RCLONE_REMOTE=$HOST  # Default to the host argument
VERBOSE=0

while getopts "l:r:n:v" opt; do
    case ${opt} in
        l) LOCAL_PATH=$OPTARG ;;
        r) REMOTE_PATH=$OPTARG ;;
        n) RCLONE_REMOTE=$OPTARG ;;
        v) VERBOSE=1 ;;
        *) usage ;;
    esac
done

mkdir -p "$LOCAL_PATH"

RCLONE_CMD="rclone mount ${RCLONE_REMOTE}:${REMOTE_PATH} ${LOCAL_PATH} --vfs-cache-mode writes --daemon"

if [ $VERBOSE -eq 1 ]; then
    echo "Rclone command: $RCLONE_CMD"
fi

eval $RCLONE_CMD

if [ $? -eq 0 ]; then
    echo "Mounted ${RCLONE_REMOTE}:${REMOTE_PATH} -> ${LOCAL_PATH}"
else
    echo "Failed to mount!"
    exit 1
fi
