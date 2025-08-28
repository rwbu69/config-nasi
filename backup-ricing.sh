#!/bin/bash
# backup-rice.sh
# Copy all ricing configs into ~/Github/config-nasi and push to GitHub

set -e

DEST=~/Github/config-nasi
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "=== Backing up configs to $DEST ==="
mkdir -p "$DEST"

# Config folders (check if exist before copying)
for dir in polybar kitty i3 rofi dunst picom; do
  if [ -d "$HOME/.config/$dir" ]; then
    cp -r "$HOME/.config/$dir" "$DEST/"
    echo "Copied $dir"
  else
    echo "Skipping $dir (not found)"
  fi
done

# Fonts
mkdir -p "$DEST/fonts"
if [ -d "$HOME/.local/share/fonts" ]; then
  cp -r "$HOME/.local/share/fonts" "$DEST/fonts/"
  echo "Copied local fonts"
fi
if [ -d "/usr/share/fonts" ]; then
  sudo cp -r /usr/share/fonts "$DEST/fonts/" 2>/dev/null || true
  echo "Copied system fonts"
fi

echo "=== Backup complete! ==="

# Git auto-push
cd "$DEST"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "=== Pushing to GitHub ==="
  git add .
  git commit -m "backup: $TIMESTAMP" || echo "Nothing new to commit."
  git push
else
  echo "Not a git repo — skipping push."
fi

echo "=== All done! ==="
