#!/bin/bash

# 将当前目录下的所有文件的文件名更正为 UTF-8 编码
travel_dir()
{
	local file
	"$GBKMV" notest *
	for file in *
	do
		if [ -d "$file" ]; then
			cd -- "$file" || exit 1
			travel_dir
			cd ..
		fi
	done
}

check_executable()
{
	if [ -f "$1" ]; then
		if [ -x "$1" ]; then
			echo "\"$1\" found"
			return 0
		else
			echo "\"$1\" has no execution permission"
			return 1
		fi
	else
		echo "\"$1\" not found"
		return 1
	fi
}

if [ $# -ne 1 ]; then
	echo "Usage: $0  ZIP_FILE"
	exit 1
fi

tempdir=$(dirname "$0")
cd "$tempdir"

export SCRIPT_LOC=$(pwd)
export GBKMV="$SCRIPT_LOC"/.gbkmv
export URI2RAW="$SCRIPT_LOC"/.uri2raw

check_executable "$GBKMV" || exit 1
check_executable "$URI2RAW" || exit 1

ZIP_PATH=$("$URI2RAW" "$NAUTILUS_SCRIPT_CURRENT_URI")
ZIP_FILE="$1"
OUTPUT_DIR=$(basename -- "$ZIP_FILE" .zip)-$(date +%N)

[ -z "$ZIP_PATH" ] && exit 2
cd -- "$ZIP_PATH" || exit 1

log_file_path=/tmp/unzip-gbk-7z-output.log
LANG=C 7z x -o"$OUTPUT_DIR" -y -- "$ZIP_FILE" > "$log_file_path"
status="$?"
cat "$log_file_path" | sed '/^[Ee]xtracting/d'
[ "$status" -ne "0" ] && exit 1
cd -- "$OUTPUT_DIR" || exit 1

travel_dir

exit 0










