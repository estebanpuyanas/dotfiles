#!/bin/bash

# app_ids / WM classes with explicit sway workspace assignments
# Keep in sync with 'assign' rules in ~/.config/sway/config
ASSIGNED=(
    "com.mitchellh.ghostty"
    "firefox"
    "thunar"
    "okular"
    "keepassxc"
)

OVERFLOW_WS='6:󰍹'

swaymsg -t subscribe '["window"]' | while IFS= read -r event; do
    change=$(printf '%s' "$event" | jq -r '.change // empty')
    [ "$change" = "new" ] || continue

    # Skip floating windows (e.g. pavucontrol, blueman-manager)
    floating=$(printf '%s' "$event" | jq -r '.container.floating // "auto_off"')
    [[ "$floating" == "auto_on" || "$floating" == "user_on" ]] && continue

    app_id=$(printf '%s' "$event" | jq -r '.container.app_id // ""')
    wm_class=$(printf '%s' "$event" | jq -r '.container.window_properties.class // ""')
    con_id=$(printf '%s' "$event" | jq -r '.container.id')

    for id in "${ASSIGNED[@]}"; do
        [[ "$app_id" == "$id" || "$wm_class" == "$id" ]] && continue 2
    done

    swaymsg "[con_id=$con_id] move container to workspace \"$OVERFLOW_WS\""
done
