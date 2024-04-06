#!/bin/bash
transfer() (
	if [ $# -eq 0 ]; then
		printf "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>\n" >&2
		return 1
	fi
	file_name=$(basename "$1")
	if [ -t 0 ]; then
		file="$1"
		if [ ! -e "$file" ]; then
			echo "$file: No such file or directory" >&2
			return 1
		fi
		if [ -d "$file" ]; then
			cd "$file" || return 1
			file_name="$file_name.zip"
			set -- zip -r -q - .
		else set -- cat "$file"; fi
	else set -- cat; fi
	url=$("$@" | curl --silent --show-error --progress-bar --upload-file "-" "https://transfer.sh/$file_name")
	echo "$url"
)
