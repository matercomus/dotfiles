#!/bin/bash

# Check if any arguments are provided
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 *.odg"
  exit 1
fi

# Loop through all .odg files passed as arguments
for file in "$@"; do
  if [[ "$file" == *.odg ]]; then
    echo "Converting $file to PDF..."
    libreoffice --headless --convert-to pdf "$file"
  else
    echo "Skipping non-ODG file: $file"
  fi
done

echo "Conversion complete."
