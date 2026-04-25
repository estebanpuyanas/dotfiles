#!/usr/bin/env bash
# Make sure to run `chmod +x install.sh` to make script executable
set -e

DOTFILES="$HOME/dotfiles"

# Optional: install packages
# sudo pacman -S --needed zsh tmux neovim git stow code sway waybar mako darkman gtklock ghostty
# yay -S visual-studio-code-bin

# Dependency check
REQUIRED_APPS=(git zsh tmux nvim code sway waybar mako darkman gtklock stow)

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

# Stow refuses to adopt symlinks it didn't create (e.g. absolute symlinks from a prior
# manual install). Remove any absolute symlinks pointing into $DOTFILES before stowing.
find "$HOME" -maxdepth 6 -type l 2>/dev/null | while IFS= read -r link; do
    target=$(readlink "$link")
    if [[ "$target" == "$DOTFILES/"* ]]; then
        rm -f "$link"
    fi
done

# Stow all packages (--no-folding creates individual file symlinks, never directory symlinks)
# Use --restow so re-runs cleanly refresh symlinks after package changes
STOW_PACKAGES=(zsh git tmux nvim ghostty ssh vscode sway waybar gtklock mako darkman scripts systemd)

for pkg in "${STOW_PACKAGES[@]}"; do
    echo "Stowing $pkg..."
    stow --no-folding --restow --dir="$DOTFILES" --target="$HOME" "$pkg"
done

# Mediatek suspend fix: targets a system path and requires sudo. Handle outside stow.
SLEEP_SCRIPT="/usr/lib/systemd/system-sleep/mediatek-suspend-fix.sh"
if [ -f "$SLEEP_SCRIPT" ] && [ ! -L "$SLEEP_SCRIPT" ]; then
    sudo rm -f "$SLEEP_SCRIPT"
fi
sudo ln -svf "$DOTFILES/scripts/mediatek-suspend-fix.sh" "$SLEEP_SCRIPT"
sudo chmod +x "$DOTFILES/scripts/mediatek-suspend-fix.sh"

echo "📦✅ Dotfiles installed."
