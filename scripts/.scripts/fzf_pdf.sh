#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
	echo "Usage: $0 <PDF files or directories...>"
	exit 1
fi

# Prompt for the search term
read -p "Enter search term: " search_term

# Use pdfgrep to search through provided PDFs and directories, extract filename and page number
# -H to show filename, -n to show page number, -i for case-insensitive search, -r for recursive search in directories
search_results=$(pdfgrep -Hnir "$search_term" "$@")

# Check if pdfgrep found any matches
if [ -z "$search_results" ]; then
	echo "No matches found for '$search_term'."
	exit 0
fi

# Use fzf to select a search result
selected_result=$(echo "$search_results" | fzf)

# If no result was selected, exit
if [ -z "$selected_result" ]; then
	echo "No selection made."
	exit 0
fi

# Extract the filename and page number from the selected result
file=$(echo "$selected_result" | cut -d ':' -f 1)
page=$(echo "$selected_result" | cut -d ':' -f 2)

# Open the PDF at the specified page using your PDF reader
"$READER" "$file" --page "$page" --find "$search_term"
