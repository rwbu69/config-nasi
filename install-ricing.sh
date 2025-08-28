#!/bin/bash
# restore-rice.sh
# Restore configs from ~/Github/config-nasi into home dir

set -e

SRC=~/Github/config-nasi

echo "=== Restoring configs from $SRC ==="

# Config folders
cp -r "$SRC/polybar" ~/.config/
cp -r "$SRC/kitty" ~/.config/
cp -r "$SRC/i3" ~/.config/
cp -r "$SRC/rofi" ~/.config/
cp -r "$SRC/dunst" ~/.config/

# Fonts
mkdir -p ~/.local/share/fonts
cp -r "$SRC/fonts/fonts"/* ~/.local/share/fonts/

# Refresh font cache
fc-cache -fv

echo "=== Restore complete! ==="
