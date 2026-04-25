#!/usr/bin/env bash
# Clipboard history manager using cliphist + wofi

MODE="${1:-pick}"

WOFI_OPTS=(--dmenu --width 600 --lines 15 --cache-file /dev/null)

case "$MODE" in
    pick)
        selected=$(cliphist list | wofi "${WOFI_OPTS[@]}" --prompt "Clipboard history")
        [ -n "$selected" ] && printf '%s' "$selected" | cliphist decode | wl-copy
        ;;
    delete)
        selected=$(cliphist list | wofi "${WOFI_OPTS[@]}" --prompt "Delete from clipboard")
        [ -n "$selected" ] && printf '%s' "$selected" | cliphist delete
        ;;
esac
