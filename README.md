# Personal Dotfiles

Configuration files for the tools I use daily on [EndeavourOS](https://endeavouros.com/) (Arch-based) with the [Sway](https://swaywm.org/) window manager. Originally written for macOS, now optimized for Linux.

Everything here is tuned for my own workflows. If you borrow anything, read through it first and strip out what does not apply to you.

## Contents

- `zsh/` - `.zshrc` and `.zprofile` with paths, aliases, and prompt settings.
- `nvim/` - Neovim 0.12 config with telescope, treesitter, fugitive, and whatever LSP I need for what I'm currently working on.
- `sway/` - Sway window manager config and helper scripts (clamshell, power menu, power profiles, ppd status). Inspired from the [EndeavourOS i3WM config](https://github.com/endeavouros-team/endeavouros-i3wm-setup).
- `waybar/` - Waybar config and stylesheet.
- `ghostty-config` - Ghostty terminal config, symlinked to `~/.config/ghostty/config`
- `vscode/` - VSCode `settings.json` and `keybindings.json`; mirrors my Neovim config as much as possible.
- `git/` - `.gitconfig` and `.gitignore_global`
- `ssh/` - Public key and SSH client config.
- `.tmux.conf` - Minimal tmux config.
- `scripts/` - Utility scripts:
  - `dark-mode-gtk.sh` / `light-mode-gtk.sh` - GTK theme hooks for `dark-mode.d` and `light-mode.d`.
  - `mediatek-suspend-fix.sh` - Unloads and reloads the mt7925e wifi driver on suspend/resume, symlinked to `/usr/lib/systemd/system-sleep/` (see script for exact issue).
- `systemd/` - Systemd service and timer for `Export-pkgs.sh`
- `pkg-lists/` - Explicitly installed `pacman` and `yay` package lists, updated on a two-week timer

## Installation

```bash
git clone https://github.com/estebanpuyanas/dotfiles ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

`install.sh` checks that required applications are installed, backs up any existing configs to `~/dotfiles_backup/`, and symlinks everything into place. The mediatek suspend fix step requires `sudo`.
