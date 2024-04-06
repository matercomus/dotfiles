#!/bin/bash

# Check if a file path is provided
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 path_to_your_file"
	exit 1
fi

# Get the file path
FILE_PATH=$1

# Use entr to watch the file and render it when it changes
echo $FILE_PATH | entr echo "require(rmarkdown); render('$FILE_PATH')" | R --vanilla
