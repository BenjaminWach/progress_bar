#!/usr/bin/env bash

#define the search path as first arg, default to current directory
search_path=${1:-.}

#enable globstar (**) and nullglob (empty array if no match)
shopt -s globstar nullglob

echo "Search in: $search_path"
files=( "$search_path"/* ) #get all files and directories in the search path: array
len=${#files[@]} #length of the array

progress-bar() {
	local current=$1
	local len=$2

	local bar_char='|'
	local empty_char=' '
	local length=50
	local percent=$((current * 100 / len))
	local filled_length=$((length * current / len))

	local i
	local s='['
	for ((i = 0; i < filled_length; i++)); do
		s+="$bar_char"
	done
	for ((i = filled_length; i < length; i++)); do
		s+=$empty_char
	done
	s+=']'
	#-ne (no newline, enable escape sequences)
	#\r cursor to start of line
	echo -ne "$s $current/$len ($percent%)\r"
}	

process_file() {
	local file=$1

	sleep 0.1
}

i=0

for file in "${files[@]}"; do
	if [[ -f "$file" ]]; then
		type="File"
	elif [[ -d "$file" ]]; then
		type="Directory"
	else
		type="Other"
	fi
	progress-bar "$((i+1))" "$len" "$file ($type)"
	process_file "$file"
	((i++))
done
echo
