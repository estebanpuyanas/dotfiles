# Personal Dotfiles

Like any dotfiles repo, this contains my ever-growing list of configuration files for applications/tools I use daily, like [VSCode](https://code.visualstudio.com/), [Neovim](https://neovim.io/), [Tmux](https://github.com/tmux/tmux), [Git](https://git-scm.com/), and [Ghostty](https://ghostty.org/).

Similarly, like any other dotfiles repo everything here has been customized for **my** workflows, conventions, and just general ways I wish to operate my machine. Originally these dots were designed for MacOS, but after ditching Apple for a Framework laptop with Linux they have been optimized for Arch-based distros like [EndeavourOS](https://endeavouros.com/), my current distro of choice.

If you wanna try these out, make sure to make a backup of your current configurations, read through each fiel and see what you like, what you'll keep, and what you'll take out; Ultimately this is designed for myself, so not everything will be to your liking.

## Explenation of the files:

- `ghostty-config`: Symlink to the Ghostty config file that lives at `~/.config/Ghostty`.

- `install.sh`: Simple shell script that verifies that required applications are installed and then applies my config into the respective application's configuration file. Good for bootsrapping a machine setup.

- `Export-pkgs.sh`: Another simple shell script that runs every two weeks and gathers a list of all my explictly installed `pacman` and `yay` packages and writes them to `.txt` files in the `pkg-lists/` directory. The respective Systemd service and timer that atuomatically execute this script are in the `systemd/` directory.

- `.zshrc`: A general `zsh` source file containing paths, aliases, and terminal color settings.

- `.tmux.conf`: My tmux configuration, not a lot has been done here, as I have just started using tmux over the summer and the default config feels mostly fine.

- `vscode/`: Contains a `keybindings.json` file for some of my custom bindings to enable zen mode, open the file explorer, and toggle the terminal. The `settings.json` file is a more expansive configuration file containing everything from colorscheme, Vim bindings, copilot, to font and formatting.

- `*.git*`: ALl of my git-related settings.

- `ssh/` my public ssh key.

- `nvim-config`: A submodule with my neovim configuration, also tracked independently in its [own repository](https://github.com/estebanpuyanas/nvim-config)
