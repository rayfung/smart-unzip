#!/bin/bash

tempdir=$(dirname "$0")
cd "$tempdir"

SCRIPT_LOC=$(pwd)

language="${LANG%%.*}"
case "$language" in
	"zh_CN"	) DISPLAY_NAME='智能解压' ;;
	"zh_TW"	) DISPLAY_NAME='智能解壓' ;;
	"zh_HK"	) DISPLAY_NAME='智能解壓' ;;
	*		) DISPLAY_NAME='smart unzip' ;;
esac

cp -v -f "$SCRIPT_LOC"/nautilus-scripts/* ~/.gnome2/nautilus-scripts
mv -v -f ~/.gnome2/nautilus-scripts/smart-unzip.sh ~/.gnome2/nautilus-scripts/"$DISPLAY_NAME"
mv -v -f ~/.gnome2/nautilus-scripts/unzip-tool.py ~/.gnome2/nautilus-scripts/.unzip-tool.py
