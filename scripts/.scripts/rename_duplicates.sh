#!/bin/bash

# Check if directory argument is provided
if [ $# -eq 0 ]; then
	echo "Usage: $0 <directory>"
	exit 1
fi

# Get the directory from command line argument
target_dir="$1"

# Check if the directory exists
if [ ! -d "$target_dir" ]; then
	echo "Error: Directory '$target_dir' does not exist."
	exit 1
fi

# Function to normalize filename (lowercase, remove extension)
normalize_filename() {
	echo "${1%.*}" | tr '[:upper:]' '[:lower:]'
}

# Function to get file extension
get_extension() {
	echo "${1##*.}"
}

# Create a temporary file to store normalized filenames
temp_file=$(mktemp)

# Find all files and store normalized names
find "$target_dir" -type f | while read -r file; do
	normalized=$(normalize_filename "$(basename "$file")")
	echo "$normalized:$file" >>"$temp_file"
done

# Sort the temp file and find duplicates
sort "$temp_file" | uniq -d -f1 | cut -d: -f1 | while read -r duplicate; do
	echo "Found duplicate: $duplicate"
	grep "^$duplicate:" "$temp_file" | cut -d: -f2 | while read -r file; do
		dir=$(dirname "$file")
		filename=$(basename "$file")
		extension=$(get_extension "$filename")
		new_name="${duplicate}_${extension}.${extension}"
		mv "$file" "${dir}/${new_name}"
		echo "Renamed: $file -> ${dir}/${new_name}"
	done
done

# Remove the temporary file
rm "$temp_file"
