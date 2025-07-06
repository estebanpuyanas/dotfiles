#!/usr/bin/env bash
# Make sure to run `chmod +x install.sh` to make script executable
set -e

DOTFILES="$HOME/dotfiles"
BACKUP="$HOME/dotfiles_backup"

# Backup any existing configs
mkdir -p "$BACKUP"
for f in .zshrc .zprofile .gitconfig .gitignore_global .tmux.conf; do
  mv -vf "$HOME/$f" "$BACKUP/" 2>/dev/null || true
done
mv -rfv ~/.config/nvim ~/.config/ghostty ~/.config/starship.toml "$BACKUP/" 2>/dev/null || true

# 1) Zsh
ln -svf "$DOTFILES/.zshrc"      "$HOME/.zshrc"
ln -svf "$DOTFILES/.zprofile"   "$HOME/.zprofile"

# 2) Git
ln -svf "$DOTFILES/.gitconfig"        "$HOME/.gitconfig"
ln -svf "$DOTFILES/.gitignore_global" "$HOME/.gitignore_global"

# 3) tmux
ln -svf "$DOTFILES/.tmux.conf"        "$HOME/.tmux.conf"

# 4) Neovim (submodule lives in nvim-config/)
mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/nvim"
ln -svf "$DOTFILES/nvim-config"       "$HOME/.config/nvim"

# 5) Ghostty
DOTFILES="$HOME/dotfiles"
GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"

mkdir -p "$GHOSTTY_DIR"
rm -f "$GHOSTTY_DIR/config"
ln -svf "$DOTFILES/ghostty-config" "$GHOSTTY_DIR/config"

# 6) SSH public key & config
mkdir -p "$HOME/.ssh"
ln -svf "$DOTFILES/ssh/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
[ -f "$DOTFILES/ssh/config" ] && ln -svf "$DOTFILES/ssh/config" "$HOME/.ssh/config"

echo "📦✅ Dotfiles installed. Backup of old files is in $BACKUP."

