#!/bin/bash

# Check if an input file was provided
if [ -z "$1" ]; then
	echo "Usage: $0 <input_file>"
	exit 1
fi

# Input file with PDF links
input_file="$1"

# Base URL (optional argument if relative links need a base URL)
base_url="$2"

# Download each PDF using wget
echo "Downloading PDFs from $input_file..."
while IFS= read -r pdf_link; do
	# Check if the link is absolute or relative
	if [[ "$pdf_link" == http* ]]; then
		full_url="$pdf_link"
	else
		full_url="$base_url$pdf_link"
	fi
	echo "Downloading: $full_url"
	wget --no-check-certificate "$full_url"
done <"$input_file"
