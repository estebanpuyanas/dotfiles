#!/usr/bin/env bash
# Outputs current power profile as JSON for waybar custom module
current=$(powerprofilesctl get 2>/dev/null || echo "unknown")
case "$current" in
    performance) printf '{"text":" Performance","class":"performance"}\n' ;;
    balanced)    printf '{"text":" Balanced","class":"balanced"}\n' ;;
    power-saver) printf '{"text":" Power Saver","class":"power-saver"}\n' ;;
    *)           printf '{"text":" %s","class":"unknown"}\n' "$current" ;;
esac
