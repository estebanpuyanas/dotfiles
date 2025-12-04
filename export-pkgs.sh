#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="$HOME/dotfiles/pkg-lists"
mkdir -p "$BACKUP_DIR"

stamp="$(date +%Y-%m-%d)"

# Explicitly installed core packages:
pacman -Qqen > "$BACKUP_DIR/pacman-native-$stamp.txt" 

# Explicitly installed AUR packages: 
pacman -Qqen > "$BACKUP_DIR/pacman-aur-$stamp.txt" 

ln -sf "pacman-native-$stamp.txt" "$BACKUP_DIR/pacman-native-latest.txt"
ln -sf "pacman-aur-$stamp.txt" "$BACKUP_DIR/pacman-aur-latest.txt"
