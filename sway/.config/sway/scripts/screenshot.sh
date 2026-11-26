#!/usr/bin/env bash
# Region screenshot: grim + slurp -> ~/Pictures/Screenshots, copied to the clipboard,
# with a notification whose "Edit" action opens the image in satty.

set -euo pipefail

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Cancelling slurp (Esc) exits non-zero: no file, no notification.
geometry="$(slurp)" || exit 0

FILE="$DIR/$(date +%Y-%m-%d-%T)-screenshot.png"
TMP="$(mktemp "$DIR/.screenshot.XXXXXX.png")"
trap 'rm -f "$TMP"' EXIT

# Capture to a temp file so a failed grim never leaves a partial screenshot behind.
grim -g "$geometry" "$TMP"
mv -- "$TMP" "$FILE"

wl-copy --type image/png < "$FILE"

# -A implies --wait; the chosen action name is printed to stdout (empty if dismissed).
# Named "default" so mako's invoke-default-action (left click) triggers it.
action="$(notify-send -i "$FILE" -A default=Edit -w "Screenshot saved" "$(basename "$FILE")" || true)"

if [ "$action" = "default" ]; then
  satty --filename "$FILE" --output-filename "$FILE" --copy-command wl-copy
fi
