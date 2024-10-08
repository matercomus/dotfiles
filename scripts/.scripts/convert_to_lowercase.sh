#!/bin/bash

# Create a function to handle the renaming process
rename_files_and_dirs() {
	local folder=$1
	local new_name
	local old_name

	# Check if there are files or directories in the given folder
	if [ -z "$(ls -A "$folder")" ]; then
		echo "The folder is empty or does not exist. Please provide a valid folder."
		exit 1
	fi

	# Rename files and directories from bottom to top
	while IFS= read -r -d '' old_name; do
		# Convert the name to lowercase
		new_name="$(dirname "${old_name}")/$(basename "${old_name}" | tr '[:upper:]' '[:lower:]')"

		# Skip if the new name is the same as the old name
		if [[ "$old_name" == "$new_name" ]]; then
			continue
		fi

		# Skip if we're trying to rename the parent directory
		if [[ "$new_name" == "./$folder" ]]; then
			continue
		fi

		# Rename the file or directory
		mv "$old_name" "$new_name"
		echo "Renaming: $old_name -> $new_name"
	done < <(find "$folder" -depth -print0)
}

# Check if the user provided a folder
if [[ -z "$1" ]]; then
	echo "Usage: $0 <folder>"
	exit 1
fi

# Call the function with the provided folder
rename_files_and_dirs "$1"
