#!/usr/bin/env bash

# Make sure to run chmod +x install.sh when transfering to Linux machine so script is executable.
set -e

# 1. Backup
mkdir -p ~/dotfiles_backup
mv ~/.gitconfig ~/.gitignore_global ~/.zshrc ~/.zprofile ~/.zshenv ~/dotfiles_backup/ 2>/dev/null || true

# 2. Symlinks
ln -svf "$PWD/.gitconfig"        ~/.gitconfig
ln -svf "$PWD/.gitignore_global" ~/.gitignore_global

ln -svf "$PWD/.zshrc"    ~/.zshrc
ln -svf "$PWD/.zprofile" ~/.zprofile
ln -svf "$PWD/.zshenv"   ~/.zshenv

echo "📦 Dotfiles installed. Backup of old files in ~/dotfiles_backup."

