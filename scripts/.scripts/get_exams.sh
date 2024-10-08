#!/bin/bash

# Correct base URL without the /exams/ part
SITE_URL="https://vu.brunet.app"
download_dir="${1:-$HOME/Downloads/vu_pdfs}" # Optional download directory argument

# Create the download directory if it doesn't exist
mkdir -p "$download_dir"

# Step 1: Fetch the course list and use fzf to select a course
echo "Fetching course list from $SITE_URL/exams/..."
course=$(curl -s -k "$SITE_URL/exams/" | grep -oP '(?<=href=")[^"]*(?=")' | grep '/exams/' | sed "s|^|$SITE_URL|" | sed 's|^//|https://|' | fzf --prompt="Select a course: ")

# Exit if no course is selected
[ -z "$course" ] && echo "No course selected, exiting..." && exit 1

echo "Selected course: $course"

# Step 2: Fetch the PDFs from the selected course
echo "Fetching PDF links from $course..."
pdf_links=$(curl -s -k "$course" | grep -oP '(?<=href=")[^"]+\.pdf')

# Check if any PDFs were found
if [ -z "$pdf_links" ]; then
	echo "No PDFs found at $course"
	exit 1
fi

# Step 3: Use fzf to select PDFs to download, with an "All" option
selected_pdfs=$(echo -e "All\n$pdf_links" | fzf --multi --prompt="Select PDFs to download: ")

# Exit if no file is selected
[ -z "$selected_pdfs" ] && echo "No files selected, exiting..." && exit 1

# Step 4: Download the selected PDFs
if [ "$selected_pdfs" == "All" ]; then
	echo "Downloading all PDFs..."
	echo "$pdf_links" | while read -r pdf; do
		# Extract the filename from the PDF link
		filename=$(basename "$pdf")
		# Construct the full URL correctly
		full_url="${course%/}/$filename"
		echo "Downloading: $full_url"
		wget --no-check-certificate -P "$download_dir" "$full_url" &
	done
else
	# Download only the selected PDFs
	echo "$selected_pdfs" | while read -r pdf; do
		# Extract the filename from the PDF link
		filename=$(basename "$pdf")
		# Construct the full URL correctly
		full_url="${course%/}/$filename"
		echo "Downloading: $full_url"
		wget --no-check-certificate -P "$download_dir" "$full_url" &
	done
fi

# Wait for all background jobs to finish
wait

echo "Download complete! Files saved to $download_dir"
