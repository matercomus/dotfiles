#!/bin/bash

# Check if a URL was provided as the first argument
if [ -z "$1" ]; then
	echo "Usage: $0 <url> [output_file]"
	exit 1
fi

# URL provided by the user
url="$1"

# Output file (default to ./pdf_links.txt if not provided)
output_file="${2:-./pdf_links.txt}"

# Use curl to fetch the page and grep to extract PDF links
curl -s -k "$url" | grep -oP '(?<=href=")[^"]+\.pdf' >"$output_file"

# Print the extracted PDF links
echo "Extracted PDF links saved to $output_file:"
cat "$output_file"
