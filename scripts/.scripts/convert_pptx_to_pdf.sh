#!/bin/bash

# Check if unoconv is installed
if ! command -v unoconv &>/dev/null; then
	echo "unoconv could not be found, please install it first."
	exit
fi

# Loop over all arguments
for file in "$@"; do
	# Check if the file has a .pptx extension
	if [[ $file == *.pptx ]]; then
		# Convert the pptx file to pdf using unoconv
		unoconv -f pdf "$file"
		echo "Converted $file to PDF."
	else
		echo "Skipping $file as it does not have a .pptx extension."
	fi
done
