#!/bin/bash

# Function to display usage message
usage() {
	echo "Usage: $0 <username> [-l <local_path_to_mount>] [-r <remote_path_to_mount>]"
	exit 1
}

# Check if the minimum number of arguments are provided
if [ "$#" -lt 1 ]; then
	usage
fi

# Assign command line arguments to variables
USERNAME=$1
shift

# Default values
SERVER_IP=130.37.53.67
LOCAL_PATH_TO_MOUNT=~/vu-hedgeiot-server
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

sshfs -o ProxyJump=${USERNAME}@ssh.data.vu.nl ${USERNAME}@${SERVER_IP}:${REMOTE_PATH_TO_MOUNT} ${LOCAL_PATH_TO_MOUNT}
