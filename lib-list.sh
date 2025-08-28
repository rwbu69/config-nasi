#!/bin/bash
# system-inventory.sh
# Generate a full list of installed packages and apps into ~/Github/config-nasi

OUTDIR=~/Github/config-nasi/system-inventory/
mkdir -p "$OUTDIR"

echo "=== Saving system inventory to $OUTDIR ==="

# Pacman packages (all)
pacman -Q >"$OUTDIR/pacman-all.txt"
echo "Saved pacman-all.txt (all installed packages)"

# Pacman explicitly installed packages
pacman -Qqe >"$OUTDIR/pacman-explicit.txt"
echo "Saved pacman-explicit.txt (explicitly installed packages)"

# AUR packages (via yay, fallback to paru if yay not installed)
if command -v yay >/dev/null 2>&1; then
  yay -Qm >"$OUTDIR/aur-packages.txt"
  echo "Saved aur-packages.txt (AUR packages via yay)"
elif command -v paru >/dev/null 2>&1; then
  paru -Qm >"$OUTDIR/aur-packages.txt"
  echo "Saved aur-packages.txt (AUR packages via paru)"
else
  echo "No yay/paru found, skipping AUR list."
fi

# Flatpak apps
if command -v flatpak >/dev/null 2>&1; then
  flatpak list --app >"$OUTDIR/flatpak-apps.txt"
  echo "Saved flatpak-apps.txt"
fi

# Snap apps
if command -v snap >/dev/null 2>&1; then
  snap list >"$OUTDIR/snap-apps.txt"
  echo "Saved snap-apps.txt"
fi

# Export shell binaries in PATH (optional, huge list)
compgen -c | sort -u >"$OUTDIR/commands.txt"
echo "Saved commands.txt (all available commands in PATH)"

echo "=== Inventory complete! Files saved in $OUTDIR ==="
