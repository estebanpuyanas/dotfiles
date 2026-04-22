#!/usr/bin/env bash
# Make sure to run `chmod +x install.sh` to make script executable
set -e

DOTFILES="$HOME/dotfiles"
BACKUP="$HOME/dotfiles_backup"

# Optional: install packages
# sudo pacman -S --needed zsh tmux neovim git 
# yay -S ghostty visual-studio-code-bin

# Dependency check:
REQUIRED_APPS=(git zsh tmux neovim code sway waybar)

MISSING_APPS=()

for app in "${REQUIRED_APPS[@]}"; do
    if ! command -v "$app" &>/dev/null; then
        MISSING_APPS+=("$app")
    fi
done

if [ ${#MISSING_APPS[@]} -ne 0 ]; then
    echo "The following required applications are missing:"
    for app in "${MISSING_APPS[@]}"; do 
        echo " - $app"
    done
    echo
    echo "Please install the missing applications and re-run the script."
    exit 1
fi

echo "All required applications are installed. Proceeding with installation..."

# Backup any existing configs
mkdir -p "$BACKUP"
for f in .zshrc .zprofile .gitconfig .gitignore_global .tmux.conf; do
  mv -vf "$HOME/$f" "$BACKUP/" 2>/dev/null || true
done
mv -rfv ~/.config/nvim ~/.config/ghostty ~/.config/sway ~/.config/waybar "$BACKUP/" 2>/dev/null || true

# 1) Zsh
ln -svf "$DOTFILES/zsh/.zshrc"      "$HOME/.zshrc"
ln -svf "$DOTFILES/zsh/.zprofile"   "$HOME/.zprofile"

# 2) Git
ln -svf "$DOTFILES/git/.gitconfig"        "$HOME/.gitconfig"
ln -svf "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"

# 3) tmux
ln -svf "$DOTFILES/.tmux.conf"        "$HOME/.tmux.conf"

# 4) Neovim
mkdir -p "$HOME/.config"
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "Backing up existing Neovim config to $BACKUP/nvim_backup_$(date +%s)"
  mv -v "$HOME/.config/nvim" "$BACKUP/nvim_backup_$(date +%s)"
fi
rm -rf "$HOME/.config/nvim"
ln -svf "$DOTFILES/nvim" "$HOME/.config/nvim"

# 5) Ghostty (Linux path)
GHOSTTY_DIR="$HOME/.config/ghostty"
mkdir -p "$GHOSTTY_DIR"
rm -f "$GHOSTTY_DIR/config"
ln -svf "$DOTFILES/ghostty-config" "$GHOSTTY_DIR/config"

# 6) SSH public key & config
mkdir -p "$HOME/.ssh"
ln -svf "$DOTFILES/ssh/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
[ -f "$DOTFILES/ssh/config" ] && ln -svf "$DOTFILES/ssh/config" "$HOME/.ssh/config"

# 7) VsCode:
VSCODE_DIR="$HOME/.config/Code/User"

if [ -d "$VSCODE_DIR" ]; then
    echo "Backing up existing VSCode configuration (settings.json, keybindings.json) to $BACKUP/vscode_backup_$(date +%s)"
    mv -v "$VSCODE_DIR/settings.json" "$BACKUP/vscode_backup_$(date +%s)" 
    mv -v "$VSCODE_DIR/keybindings.json" "$BACKUP/vscode_backup_$(date +%s)" 
fi

ln -svf "$DOTFILES/vscode/settings.json"    "$HOME/.config/Code/User/settings.json"
ln -svf "$DOTFILES/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"

# 8) Sway
SWAY_DIR="$HOME/.config/sway"
if [ -d "$SWAY_DIR" ] && [ ! -L "$SWAY_DIR" ]; then
  echo "Backing up existing Sway config to $BACKUP/sway_backup_$(date +%s)"
  mv -v "$SWAY_DIR" "$BACKUP/sway_backup_$(date +%s)"
fi
rm -rf "$SWAY_DIR"
ln -svf "$DOTFILES/sway" "$SWAY_DIR"

# 9) Waybar
WAYBAR_DIR="$HOME/.config/waybar"
if [ -d "$WAYBAR_DIR" ] && [ ! -L "$WAYBAR_DIR" ]; then
  echo "Backing up existing Waybar config to $BACKUP/waybar_backup_$(date +%s)"
  mv -v "$WAYBAR_DIR" "$BACKUP/waybar_backup_$(date +%s)"
fi
rm -rf "$WAYBAR_DIR"
ln -svf "$DOTFILES/waybar" "$WAYBAR_DIR"

# 10) GTK dark/light mode hooks
mkdir -p "$HOME/.local/share/dark-mode.d" "$HOME/.local/share/light-mode.d"
rm -f "$HOME/.local/share/dark-mode.d/gtk.sh" "$HOME/.local/share/light-mode.d/gtk.sh"
ln -svf "$DOTFILES/scripts/dark-mode-gtk.sh"  "$HOME/.local/share/dark-mode.d/gtk.sh"
ln -svf "$DOTFILES/scripts/light-mode-gtk.sh" "$HOME/.local/share/light-mode.d/gtk.sh"

# 11) Mediatek suspend fix (requires sudo)
SLEEP_SCRIPT="/usr/lib/systemd/system-sleep/mediatek-suspend-fix.sh"
if [ -f "$SLEEP_SCRIPT" ] && [ ! -L "$SLEEP_SCRIPT" ]; then
  sudo rm -f "$SLEEP_SCRIPT"
fi
sudo ln -svf "$DOTFILES/scripts/mediatek-suspend-fix.sh" "$SLEEP_SCRIPT"
sudo chmod +x "$DOTFILES/scripts/mediatek-suspend-fix.sh"

echo "📦✅ Dotfiles installed. Backup of old files is in $BACKUP."
