#!/bin/bash

tempdir=$(dirname "$0")
cd "$tempdir"

SCRIPT_LOC=$(pwd)

cp -v -f "$SCRIPT_LOC"/nautilus-scripts/* ~/.gnome2/nautilus-scripts
mv ~/.gnome2/nautilus-scripts/unzip-tool.py ~/.gnome2/nautilus-scripts/.unzip-tool.py
