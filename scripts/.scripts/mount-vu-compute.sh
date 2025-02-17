#!/bin/bash

# Function to display usage message
usage() {
	echo "Usage: $0 <username> <node> [-l <local_path_to_mount>] [-r <remote_path_to_mount>] [-v]"
	exit 1
}

# Check if the minimum number of arguments are provided
if [ "$#" -lt 2 ]; then
	usage
fi

# Assign command line arguments to variables
USERNAME=$1
NODE=$2
shift 2

# Default values
LOCAL_PATH_TO_MOUNT=~/vu-compute
REMOTE_PATH_TO_MOUNT=/home/${USERNAME}/
VERBOSE=false

# Parse optional flags
while getopts "l:r:v" opt; do
	case ${opt} in
	l)
		LOCAL_PATH_TO_MOUNT=$OPTARG
		;;
	r)
		REMOTE_PATH_TO_MOUNT=$OPTARG
		;;
	v)
		VERBOSE=true
		;;
	\?)
		usage
		;;
	esac
done

# Construct the sshfs command
SSHFS_CMD="sshfs -o ProxyJump=${USERNAME}@ssh.data.vu.nl ${USERNAME}@${NODE}.compute.vu.nl:${REMOTE_PATH_TO_MOUNT} ${LOCAL_PATH_TO_MOUNT}"

# Print the command if verbose mode is enabled
if [ "$VERBOSE" = true ]; then
	echo "Running command: $SSHFS_CMD"
fi

# Execute the sshfs command
$SSHFS_CMD
