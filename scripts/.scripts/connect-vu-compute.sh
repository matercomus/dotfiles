#!/bin/bash

# Function to display usage message
usage() {
	echo "Usage: $0 <username> <node> [-l <local_path_to_mount>] [-r <remote_path_to_mount>]"
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

# Parse optional flags
while getopts "l:r:" opt; do
	case ${opt} in
	l)
		LOCAL_PATH_TO_MOUNT=$OPTARG
		;;
	r)
		REMOTE_PATH_TO_MOUNT=$OPTARG
		;;
	\?)
		usage
		;;
	esac
done

sshfs -o ProxyJump=${USERNAME}@ssh.data.vu.nl ${USERNAME}@${NODE}.compute.vu.nl:${REMOTE_PATH_TO_MOUNT} ${LOCAL_PATH_TO_MOUNT}
