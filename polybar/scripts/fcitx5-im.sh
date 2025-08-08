#!/bin/bash

# Get current input method from fcitx5
im=$(fcitx5-remote -n)

# Optionally shorten long names
case "$im" in
"mozc-jp") echo "あ" ;;
"keyboard-us") echo "EN" ;;
*) echo "$im" ;;
esac
