#!/usr/bin/env bash
pkill -x polybar 2>/dev/null
sleep 0.2

# For each connected monitor, start both bars
for m in $(polybar -m | cut -d: -f1); do
  MONITOR="$m" polybar -q top -c ~/.config/polybar/config.ini &
  MONITOR="$m" polybar -q bottom -c ~/.config/polybar/config.ini &
done
