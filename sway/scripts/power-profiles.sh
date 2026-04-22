#!/usr/bin/env bash
# Power-profiles switcher using wofi (sway/Wayland adaptation of i3 version)
command -v powerprofilesctl >/dev/null 2>&1 || { notify-send "Error" "powerprofilesctl not found"; exit 1; }

current=$(powerprofilesctl get 2>/dev/null)

cancel=$' Cancel'
perf=$' Performance'
balanced=$' Balanced'
powersave=$' Power Saver'

options="$cancel"
powerprofilesctl list | grep -q "performance"  && options="$options\n$perf"
powerprofilesctl list | grep -q "balanced"     && options="$options\n$balanced"
powerprofilesctl list | grep -q "power-saver"  && options="$options\n$powersave"

chosen=$(printf '%b' "$options" | wofi --show dmenu \
    --prompt "Current: $current" \
    --width 300 --height 180 \
    --no-actions --insensitive)

case "$chosen" in
    "$perf")      powerprofilesctl set performance  ;;
    "$balanced")  powerprofilesctl set balanced      ;;
    "$powersave") powerprofilesctl set power-saver   ;;
    *)            exit 0 ;;
esac

notify-send -i dialog-information "Power Profile" "Switched to: ${chosen#* }" 2>/dev/null || true
