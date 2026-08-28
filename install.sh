#!/usr/bin/env bash
# Make sure to run `chmod +x install.sh` to make script executable
set -e

DOTFILES="$HOME/dotfiles"

# Hand-curated package list (deliberately NOT sourced from pkg-lists/, which is
# just a periodic export snapshot of one machine's state, not an install manifest).
PACMAN_PACKAGES=(
    # base tooling
    git zsh tmux neovim stow
    # graphical login
    ly
    # sway desktop + ecosystem referenced by sway/.config/sway/config and its scripts
    sway waybar mako gtklock swayosd wofi cliphist swaybg swayidle polkit-gnome
    grim slurp jq wl-clipboard brightnessctl playerctl kdeconnect
    xdg-desktop-portal-gtk
    # applications launched/assigned from sway config
    ghostty firefox thunar keepassxc okular
    # theming + power services
    darkman power-profiles-daemon
    # shell environment
    direnv pyenv zsh-autosuggestions zsh-syntax-highlighting
)

AUR_PACKAGES=(brave-bin minecraft-launcher balena-etcher)

echo "Installing pacman packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

if command -v yay &>/dev/null; then
    echo "Installing AUR packages..."
    yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
else
    echo "yay not found; skipping AUR packages: ${AUR_PACKAGES[*]}"
fi

# Oh My Zsh is required by zsh/.zshrc but isn't a pacman/AUR package.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Dependency check
REQUIRED_APPS=(git zsh tmux nvim code sway waybar mako darkman gtklock stow swayosd-client ly ghostty direnv pyenv)

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
STOW_PACKAGES=(zsh git tmux nvim ghostty ssh vscode sway waybar gtklock mako darkman scripts systemd swayosd herdr)

for pkg in "${STOW_PACKAGES[@]}"; do
    echo "Stowing $pkg..."
    stow --no-folding --restow --dir="$DOTFILES" --target="$HOME" "$pkg"
done

# Enable services the stowed configs depend on
sudo systemctl enable --now ly.service
sudo systemctl enable --now power-profiles-daemon.service
systemctl --user enable --now darkman.service
systemctl --user enable --now export-pkgs.timer

# Mediatek suspend fix: targets a system path and requires sudo. Handle outside stow.
SLEEP_SCRIPT="/usr/lib/systemd/system-sleep/mediatek-suspend-fix.sh"
if [ -f "$SLEEP_SCRIPT" ] && [ ! -L "$SLEEP_SCRIPT" ]; then
    sudo rm -f "$SLEEP_SCRIPT"
fi
sudo ln -svf "$DOTFILES/scripts/mediatek-suspend-fix.sh" "$SLEEP_SCRIPT"
sudo chmod +x "$DOTFILES/scripts/mediatek-suspend-fix.sh"

echo "📦✅ Dotfiles installed."
