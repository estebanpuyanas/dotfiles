#!/usr/bin/env bash
# Make sure to run `chmod +x install.sh` to make script executable
set -e

DOTFILES="$HOME/dotfiles"
BACKUP="$HOME/dotfiles_backup"

# Optional: install packages
# sudo pacman -S --needed zsh tmux neovim git 
# yay -S ghostty visual-studio-code-bin

# Dependency check:
REQUIRED_APPS=(git zsh tmux neovim code)

MISSING_APPS=()

for app in "${REQUIRED_APPS[@]}"; do
    if ! command -v "$app" &>/dev/null; then
        MISSING_APPS+=("$app")
    fi
done

if [${#MISSING_APPS[@]} -ne 0]; then
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
mv -rfv ~/.config/nvim ~/.config/ghostty "$BACKUP/" 2>/dev/null || true

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

# Backup existing neovim config
if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing Neovim configuration $BACKUP/nvim_backup_$(date + %s)"
    mv -v "$HOME/.config/nvim" "$BACKUP/nvim_backup_$(date +s)" 
fi

# Esure the nvim-config.git submodule is initialized:
if [ ! -d "$DOTFILES/nvim-config/.git" ]; then
    echo "Neovim configuration submodule not found! Initializing..."
    git -C "$DOTFILES" submodule update --init --recursive
else
    echo "Neovim config submodule found"
fi 

# Remove old folder/symlink:
rm -rf "$HOME/.config/nvim"

# Add the new one:
ln -svf "$DOTFILES/nvim-config"       "$HOME/.config/nvim"

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

echo "📦✅ Dotfiles installed. Backup of old files is in $BACKUP."
