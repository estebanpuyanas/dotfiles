#!/bin/bash
# Dynamic display management for sway.
# Disables the laptop screen when a real external monitor is detected (via EDID),
# and re-enables it when none is found. Output name is discovered at runtime so it
# works regardless of which port the Anker hub enumerates as (DP-3, DP-4, etc.).

LAPTOP="eDP-1"
EXT_SCALE=1
EXT_MODE="1920x1080@100Hz"
LAPTOP_SCALE=1.5

# Find the first non-laptop output that has EDID make/model data (real monitor).
# Virtual or dummy outputs from hubs without a monitor attached typically have no
# EDID and show up with an empty or "Unknown" make.
EXTERNAL=$(swaymsg -t get_outputs | python3 -c "
import json, sys
outputs = json.load(sys.stdin)
for o in outputs:
    name = o.get('name', '')
    make = o.get('make', '').strip()
    modes = o.get('modes', [])
    if name == 'eDP-1':
        continue
    if make and make != 'Unknown' and len(modes) > 0:
        print(name)
        break
" 2>/dev/null)

if [ -n "$EXTERNAL" ]; then
    swaymsg "output $LAPTOP disable"
    swaymsg "output $EXTERNAL enable scale $EXT_SCALE mode $EXT_MODE"
else
    swaymsg "output $LAPTOP enable scale $LAPTOP_SCALE"
fi
