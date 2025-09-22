#!/bin/bash
# install-all.sh
# Restore ricing configs and reinstall packages from system-inventory

set -e

REPO=~/Github/config-nasi
INVENTORY=$REPO/system-inventory

echo "=== Starting full system restore ==="

# 1. Run install-ricing.sh
if [ -f "$REPO/install-ricing.sh" ]; then
  echo ">>> Running install-ricing.sh..."
  bash "$REPO/install-ricing.sh"
else
  echo "install-ricing.sh not found in $REPO"
fi

# 2. Reinstall packages from system-inventory
if [ -f "$INVENTORY/pacman-explicit.txt" ]; then
  echo ">>> Installing pacman packages..."
  sudo pacman -S --needed - <"$INVENTORY/pacman-explicit.txt"
else
  echo "pacman-explicit.txt not found, skipping pacman restore."
fi

if [ -f "$INVENTORY/aur-packages.txt" ]; then
  echo ">>> Installing AUR packages..."
  if command -v yay >/dev/null 2>&1; then
    yay -S --needed - <"$INVENTORY/aur-packages.txt"
  elif command -v paru >/dev/null 2>&1; then
    paru -S --needed - <"$INVENTORY/aur-packages.txt"
  else
    echo "No yay/paru found. Please install an AUR helper first."
  fi
else
  echo "aur-packages.txt not found, skipping AUR restore."
fi

if [ -f "$INVENTORY/flatpak-apps.txt" ]; then
  echo ">>> Installing Flatpak apps..."
  while read -r app; do
    flatpak install -y --noninteractive "$app" || true
  done <"$INVENTORY/flatpak-apps.txt"
fi

if [ -f "$INVENTORY/snap-apps.txt" ]; then
  echo ">>> Installing Snap apps..."
  # Skip the header line
  tail -n +2 "$INVENTORY/snap-apps.txt" | awk '{print $1}' | while read -r app; do
    sudo snap install "$app" || true
  done
fi

echo "=== System restore complete! ==="
