#!/usr/bin/env bash
# Power/logout menu using wofi (sway/Wayland adaptation of i3 version)

cancel=$' Cancel'
lock=$' Lock'
logout=$' Logout'
reboot=$' Reboot'
shutdown=$' Shutdown'
suspend=$' Suspend'
hibernate=$' Hibernate'

options="$cancel\n$lock\n$logout\n$reboot\n$shutdown\n$suspend\n$hibernate"

chosen=$(printf '%b' "$options" | wofi --show dmenu \
    --prompt "Power" \
    --width 280 --height 290 \
    --no-actions --insensitive)

case "$chosen" in
    "$lock")      swaylock -f -c 000000 ;;
    "$logout")    swaymsg exit ;;
    "$reboot")    systemctl reboot ;;
    "$shutdown")  systemctl poweroff ;;
    "$suspend")   systemctl suspend ;;
    "$hibernate") systemctl hibernate ;;
    *)            exit 0 ;;
esac
