# Project agent memory

This file is the project's committed home for project-intrinsic agent knowledge: build, test, release, architecture, and sharp-edge notes that should travel with the code.

- Add durable project-specific notes here as they are discovered through real work.
- `install.sh`'s `PACMAN_PACKAGES`/`AUR_PACKAGES` are a hand-curated install manifest, deliberately independent of `pkg-lists/` (which is only a periodic export snapshot of one machine's current state, written by `zsh/export-pkgs.sh`, and may pin older-than-ISO versions). When a stowed config starts depending on a new binary, add it to `install.sh` directly — do not point `install.sh` at `pkg-lists/`.
- `install.sh` is the single source of truth for what a clean EndeavourOS install needs: package installs, Oh My Zsh bootstrap, stow, and the `ly`/`darkman`/`power-profiles-daemon`/`export-pkgs.timer` service enables all live there. Keep new bring-up steps idempotent (`pacman -S --needed`, `systemctl enable`) so re-running the script stays safe.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
