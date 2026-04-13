#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="$HOME/dotfiles/pkg-lists"
mkdir -p "$BACKUP_DIR"

stamp="$(date +%Y-%m-%d)"

# Explicitly installed core packages:
pacman -Qqen > "$BACKUP_DIR/pacman-native-$stamp.txt" 

# Explicitly installed AUR packages:
pacman -Qqem > "$BACKUP_DIR/pacman-aur-$stamp.txt"

ln -sf "pacman-native-$stamp.txt" "$BACKUP_DIR/pacman-native-latest.txt"
ln -sf "pacman-aur-$stamp.txt" "$BACKUP_DIR/pacman-aur-latest.txt"

# Remove all previous dated files, keeping only the current run
find "$BACKUP_DIR" -maxdepth 1 -type f -name 'pacman-*.txt' ! -name "*-$stamp.txt" -delete
