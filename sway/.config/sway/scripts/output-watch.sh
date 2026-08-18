#!/bin/bash
# Re-runs clamshell.sh whenever sway's output list changes (monitor plugged
# or unplugged), not just on lid switch events. Needed because unplugging the
# external monitor while the lid is ajar (not fully closed) never fires a
# lid:on/off event, so clamshell.sh would otherwise never re-enable eDP-1.

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
LOCK=/tmp/clamshell-output-watch.lock

swaymsg -t subscribe -m '["output"]' | while read -r _; do
    # clamshell.sh's own "output enable/disable" calls generate more output
    # events, so coalesce bursts into a single run instead of looping.
    flock -n "$LOCK" -c "sleep 0.3 && '$SCRIPT_DIR/clamshell.sh'" &
done
