#!/bin/bash

# 将当前目录下的所有文件的文件名更正为 UTF-8 编码
travel_dir()
{
	local file
	"$UNZIP_TOOL" mv *
	for file in *
	do
		if [ -d "$file" ]; then
			cd -- "$file" || return 1
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

get_unique_dir()
{
	u_dir="$1"
	if [ -e "$u_dir" ]; then
		i=2
		while [ -e "$u_dir ($i)" ]
		do
			i=$((i+1))
		done
		printf "%s" "$u_dir ($i)"
	else
		printf "%s" "$u_dir"
	fi
}

smart_unzip()
{
	ZIP_PATH=$("$UNZIP_TOOL" uri "$NAUTILUS_SCRIPT_CURRENT_URI")
	ZIP_FILE="$1"
	OUTPUT_DIR=$(basename -- "$ZIP_FILE" .zip)

	[ -z "$ZIP_PATH" ] && return 2
	cd -- "$ZIP_PATH" || return 1

	if [ "${ZIP_FILE##*.}" != "zip" ]; then
		zenity --info --text="“$ZIP_FILE”不是zip压缩文件"
		return 1
	fi
	if [ -z "$OUTPUT_DIR" ]; then
		OUTPUT_DIR='zip'
	fi
	OUTPUT_DIR=$(get_unique_dir "$OUTPUT_DIR")
	log_file_path=/tmp/unzip-gbk-7z-output.log
	LANG=C 7z l -- "$ZIP_FILE" | sed '/^[^0-9]/d' > "$log_file_path"
	encoding=$("$UNZIP_TOOL" detect "$log_file_path")
	if [ "$encoding" == "utf-8" ]; then
		7z x -o"$OUTPUT_DIR" -y -- "$ZIP_FILE" > "$log_file_path"
	else
		LANG=C 7z x -o"$OUTPUT_DIR" -y -- "$ZIP_FILE" > "$log_file_path"
		status="$?"
		[ "$status" -ne "0" ] && return 1
		cd -- "$OUTPUT_DIR" || return 1

		travel_dir

		return 0
	fi
}

if [ "$#" -ne "1" ]; then
	zenity --info --text="必须有且只有一个命令行参数"
	exit 1
fi

tempdir=$(dirname "$0")
cd "$tempdir"

export SCRIPT_LOC=$(pwd)
export UNZIP_TOOL="$SCRIPT_LOC"/.unzip-tool.py

check_executable "$UNZIP_TOOL" || exit 1

(echo 0 ; smart_unzip "$1" > /dev/null ; echo 100) | \
	zenity --progress --text='正在解压……' --auto-close --no-cancel --pulsate
