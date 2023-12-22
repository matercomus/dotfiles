#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
	echo "Usage: $0 search_string [directory]"
	exit 1
fi

# Get the search string from the command line arguments
search_string=$1

# Get the directory from the command line arguments, or default to '.'
dir=${2:-.}

# Iterate over each PDF file in the specified directory
for file in "$dir"/*.pdf; do
	# Check if the file exists
	if [ -f "$file" ]; then
		echo "Processing $file"
		# Convert the PDF to text and search for the string
		pdftotext "$file" - | grep --color -in "$search_string"
	fi
done
