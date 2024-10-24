#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
	echo "Usage: $0 <PDF files or directories...>"
	exit 1
fi

# Check if pdftotext is installed
if ! command -v pdftotext &>/dev/null; then
	echo "pdftotext could not be found. Please install it."
	exit 1
fi

# Create a temporary directory to store extracted text files
temp_dir=$(mktemp -d)

# Function to clean up temporary files
cleanup() {
	rm -rf "$temp_dir"
}
trap cleanup EXIT

# Extract text from provided PDFs and directories
for item in "$@"; do
	if [ -d "$item" ]; then
		find "$item" -name '*.pdf' -exec sh -c '
            temp_dir="$1"
            for pdf; do
                echo "Processing $pdf"
                output_file="$temp_dir/$(basename "$pdf" .pdf).txt"
                echo "Output file: $output_file"
                pdftotext -layout "$pdf" "$output_file"
                if [ ! -f "$output_file" ]; then
                    echo "Failed to create text file for $pdf"
                fi
            done
        ' sh "$temp_dir" {} +
	elif [ -f "$item" ] && [[ "$item" == *.pdf ]]; then
		echo "Processing $item"
		output_file="$temp_dir/$(basename "$item" .pdf).txt"
		echo "Output file: $output_file"
		pdftotext -layout "$item" "$output_file"
		if [ ! -f "$output_file" ]; then
			echo "Failed to create text file for $item"
		fi
	fi
done

# Use fzf to search through the extracted text files interactively
selected_result=$(grep -Hnir "" "$temp_dir" | fzf)

# If no result was selected, exit
if [ -z "$selected_result" ]; then
	echo "No selection made."
	exit 0
fi

# Extract the filename, line number, and search term from the selected result
file=$(echo "$selected_result" | cut -d ':' -f 1)
line=$(echo "$selected_result" | cut -d ':' -f 2)
search_term=$(echo "$selected_result" | cut -d ':' -f 3-)

# Clean up the search term by preserving common punctuation marks
search_term=$(echo "$search_term" | sed 's/[^a-zA-Z0-9 ,:.-]//g' | xargs)

# Debug information
echo "Selected file: $file"
echo "Line number: $line"
echo "Search term: $search_term"

# Map the text file back to the original PDF file
pdf_file=$(basename "$file" .txt).pdf
pdf_path=$(find "$@" -name "$pdf_file" -print -quit)

# Debug information
echo "PDF file: $pdf_file"
echo "PDF path: $pdf_path"

# Open the PDF and search for the term using Zathura
zathura -f "$search_term" "$pdf_path" & disown
