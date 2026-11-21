#!/usr/bin/env bash
# install-nvim.sh: set up only the Neovim config from this dotfiles repo.
#
# Remote (no clone needed):
#   curl -fsSL https://raw.githubusercontent.com/estebanpuyanas/dotfiles/main/install-nvim.sh | bash
#   curl -fsSL .../install-nvim.sh | bash -s -- --bootstrap
#
# Local (inside an existing clone):
#   chmod +x install-nvim.sh && ./install-nvim.sh
#
# What it does:
#   1. Finds the config. Inside a checkout it uses that checkout. Otherwise it
#      makes a shallow, blobless, sparse clone of only nvim/ into
#      ${XDG_DATA_HOME:-$HOME/.local/share}/nvim-config-repo (re-run to update).
#   2. Symlinks nvim/.config/nvim to ${XDG_CONFIG_HOME:-$HOME/.config}/nvim.
#      A different existing config is moved to a timestamped backup, never deleted.
#   3. Checks external tools and prints install hints. It never installs packages.
#   4. Optionally bootstraps plugins with a headless nvim run.
#
# Options:
#   --bootstrap       run the headless plugin bootstrap without asking
#   --no-bootstrap    skip the bootstrap and do not ask
#   -h, --help        show this help
#
# Environment overrides:
#   NVIM_CONFIG_REPO_URL     clone URL (default: the HTTPS GitHub URL)
#   NVIM_CONFIG_REPO_BRANCH  branch to clone (default: the remote default branch)
#   NVIM_CONFIG_REPO_DIR     where the sparse clone lives
#   NVIM_BOOTSTRAP           1 or 0, same as --bootstrap / --no-bootstrap

set -euo pipefail

REPO_URL="${NVIM_CONFIG_REPO_URL:-https://github.com/estebanpuyanas/dotfiles.git}"
REPO_BRANCH="${NVIM_CONFIG_REPO_BRANCH:-}"
REPO_DIR="${NVIM_CONFIG_REPO_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/nvim-config-repo}"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
LINK_PATH="$CONFIG_HOME/nvim"
CONFIG_REL="nvim/.config/nvim"
MIN_NVIM_MAJOR=0
MIN_NVIM_MINOR=12
BOOTSTRAP="${NVIM_BOOTSTRAP:-ask}"

say()  { printf '%s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

usage() {
    # Print the leading comment block, minus the shebang and the comment markers.
    sed -n '2,/^$/p' "$0" 2>/dev/null | sed 's/^# \{0,1\}//' || true
}

while [ $# -gt 0 ]; do
    case "$1" in
        --bootstrap)    BOOTSTRAP=1 ;;
        --no-bootstrap) BOOTSTRAP=0 ;;
        -h|--help)      usage; exit 0 ;;
        *)              die "unknown option: $1 (try --help)" ;;
    esac
    shift
done

have() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------- distro hints

PM=""
detect_pm() {
    if [ "$(uname -s)" = "Darwin" ]; then
        PM=brew
    elif have apt-get; then
        PM=apt
    elif have dnf; then
        PM=dnf
    elif have pacman; then
        PM=pacman
    fi
}
detect_pm

# hint <apt-name> <dnf-name> <pacman-name> <brew-name>
hint() {
    case "$PM" in
        apt)    say "      sudo apt install $1" ;;
        dnf)    say "      sudo dnf install $2" ;;
        pacman) say "      sudo pacman -S $3" ;;
        brew)   say "      brew install $4" ;;
        *)      say "      install: $1 (package names vary by distro)" ;;
    esac
}

# ------------------------------------------------------------- locate the repo

# Resolve the directory this script lives in, or empty when piped from curl.
script_dir() {
    local src="${BASH_SOURCE[0]:-}"
    [ -n "$src" ] && [ -f "$src" ] || return 0
    ( cd "$(dirname "$src")" 2>/dev/null && pwd -P ) || true
}

find_local_repo() {
    local dir
    dir="$(script_dir)"
    [ -n "$dir" ] || return 0
    # The script sits at the repo root; accept it only if the config is there.
    if [ -f "$dir/$CONFIG_REL/init.lua" ]; then
        printf '%s\n' "$dir"
    fi
}

ensure_remote_clone() {
    if [ -d "$REPO_DIR/.git" ]; then
        say "Updating existing sparse clone at $REPO_DIR"
        # A failed pull (offline, diverged) should not block linking an existing copy.
        git -C "$REPO_DIR" pull --ff-only --quiet || warn "git pull failed, using the existing copy"
    else
        if [ -e "$REPO_DIR" ] && [ -n "$(ls -A "$REPO_DIR" 2>/dev/null)" ]; then
            die "$REPO_DIR exists and is not a git clone. Move it or set NVIM_CONFIG_REPO_DIR."
        fi
        say "Cloning only nvim/ from $REPO_URL into $REPO_DIR"
        mkdir -p "$(dirname "$REPO_DIR")"
        if [ -n "$REPO_BRANCH" ]; then
            git clone --quiet --depth 1 --filter=blob:none --sparse \
                --branch "$REPO_BRANCH" "$REPO_URL" "$REPO_DIR"
        else
            git clone --quiet --depth 1 --filter=blob:none --sparse "$REPO_URL" "$REPO_DIR"
        fi
        git -C "$REPO_DIR" sparse-checkout set nvim
    fi
    [ -f "$REPO_DIR/$CONFIG_REL/init.lua" ] \
        || die "clone at $REPO_DIR has no $CONFIG_REL/init.lua"
}

# ------------------------------------------------------------------- the link

backup_stamp() { date +%Y%m%d-%H%M%S; }

link_config() {
    local src="$1/$CONFIG_REL"
    mkdir -p "$CONFIG_HOME"

    if [ -L "$LINK_PATH" ]; then
        local cur
        cur="$(readlink "$LINK_PATH")"
        if [ "$cur" = "$src" ]; then
            say "Already linked: $LINK_PATH -> $src"
            return 0
        fi
        # Same directory reached through a different path (e.g. a symlinked $HOME).
        if [ -d "$LINK_PATH" ] && [ "$(cd -P "$LINK_PATH" && pwd -P)" = "$(cd -P "$src" && pwd -P)" ]; then
            say "Already linked: $LINK_PATH -> $cur"
            return 0
        fi
    fi

    if [ -e "$LINK_PATH" ] || [ -L "$LINK_PATH" ]; then
        local backup stamp
        stamp="$(backup_stamp)"
        backup="$LINK_PATH.bak-$stamp"
        # Never clobber an earlier backup made in the same second.
        while [ -e "$backup" ] || [ -L "$backup" ]; do backup="$backup-1"; done
        mv "$LINK_PATH" "$backup"
        say "Existing config moved to $backup"
    fi

    ln -s "$src" "$LINK_PATH"
    say "Linked $LINK_PATH -> $src"
}

# -------------------------------------------------------------- dependency check

MISSING=0

# check_tool <label> <command...> -- what it is for; then hint on a following line
miss() {
    MISSING=$((MISSING + 1))
    warn "missing: $1 ($2)"
}

nvim_version_ok() {
    local ver major minor
    ver="$(nvim --version 2>/dev/null | sed -n '1s/^NVIM v\([0-9][0-9]*\.[0-9][0-9]*\).*/\1/p')"
    [ -n "$ver" ] || return 1
    major="${ver%%.*}"
    minor="${ver#*.}"
    if [ "$major" -gt "$MIN_NVIM_MAJOR" ]; then return 0; fi
    [ "$major" -eq "$MIN_NVIM_MAJOR" ] && [ "$minor" -ge "$MIN_NVIM_MINOR" ]
}

check_deps() {
    say ""
    say "Checking external tools (nothing is installed for you)..."

    # git was already required, but report it for the local-mode path too.
    have git || miss git "required"

    if ! have nvim; then
        miss neovim "need >= $MIN_NVIM_MAJOR.$MIN_NVIM_MINOR for vim.pack"
        say "    Get a recent build: brew install neovim, bob (https://github.com/MordechaiHadad/bob),"
        say "    or the upstream release: https://github.com/neovim/neovim/releases"
    elif ! nvim_version_ok; then
        miss "neovim $MIN_NVIM_MAJOR.$MIN_NVIM_MINOR+" "found $(nvim --version | sed -n 1p); vim.pack needs 0.12"
        say "    Distro packages are often older. Use brew install neovim, bob"
        say "    (https://github.com/MordechaiHadad/bob), or https://github.com/neovim/neovim/releases"
    fi

    if ! have cc && ! have gcc && ! have clang; then
        miss "C compiler" "builds some treesitter parsers and plugins"
        hint build-essential "gcc" "base-devel" "gcc"
    fi
    if ! have make; then
        miss make "builds native pieces"
        hint build-essential "make" "base-devel" "make"
    fi
    if ! have tree-sitter; then
        miss tree-sitter-cli "nvim-treesitter (main branch) compiles parsers with it"
        say "      npm install -g tree-sitter-cli  |  cargo install tree-sitter-cli  |  brew install tree-sitter-cli"
        if [ "$PM" = pacman ]; then say "      sudo pacman -S tree-sitter-cli"; fi
    fi
    if ! have rg; then
        miss ripgrep "telescope live_grep"
        hint ripgrep ripgrep ripgrep ripgrep
    fi
    if ! have fd && ! have fdfind; then
        miss fd "telescope find_files uses it when present"
        hint fd-find fd-find fd fd
    fi
    if ! have curl && ! have wget; then
        miss "curl or wget" "mason downloads LSP servers with them"
        hint curl curl curl curl
    fi
    if ! have unzip; then
        miss unzip "mason unpacks some LSP servers with it"
        hint unzip unzip unzip unzip
    fi
    if ! have tar || ! have gzip; then
        miss "tar and gzip" "mason unpacks some LSP servers with them"
        hint "tar gzip" "tar gzip" "tar gzip" "gnu-tar"
    fi
    if ! have node || ! have npm; then
        miss "node and npm" "mason installs pyright, ts_ls, eslint, html, css, json, docker and marksman servers with npm; also copilot.vim"
        hint "nodejs npm" "nodejs npm" "nodejs npm" "node"
    fi
    if ! have go; then
        miss go "mason builds gopls with it"
        hint golang-go golang go go
    fi
    if ! have python3; then
        miss python3 "some mason packages and pyright tooling expect it"
        hint python3 python3 python python
    fi

    say ""
    say "Optional: prettier or prettierd (web formatting on save), ruff (python formatting),"
    say "gofmt ships with go. Install them with :MasonInstall prettierd ruff inside nvim."

    if [ "$MISSING" -eq 0 ]; then
        say "All checked tools are present."
    else
        warn "$MISSING tool group(s) missing. The config is linked anyway; install them and re-run."
    fi
}

# ------------------------------------------------------------------- bootstrap

# vim.pack.add() in init.lua installs missing plugins on a normal startup, even
# headless, so one --headless run fetches all of them. Treesitter parser builds
# are asynchronous and would be killed by an immediate :qa, so a second run waits
# on them. Mason LSP servers also install asynchronously; they finish the first
# time you open nvim interactively, which is not reliably scriptable, so we skip them.
bootstrap_plugins() {
    say ""
    say "Bootstrapping plugins (headless, needs network, can take a few minutes)..."
    if ! nvim --headless +qa; then
        warn "headless plugin install exited non-zero; open nvim and run :checkhealth vim.pack"
        return 0
    fi
    if have tree-sitter && { have cc || have gcc || have clang; }; then
        # Keep this list in step with nvim/.config/nvim/lua/plugins/treesitter.lua.
        nvim --headless "+lua local ok, ts = pcall(require, 'nvim-treesitter'); if ok then ts.install({'c','cpp','python','dockerfile','html','lua','sql','tsx','typescript','javascript','css','json','markdown','markdown_inline','go','kotlin'}):wait(600000) end" +qa \
            || warn "treesitter parser build did not finish cleanly; it will retry on next start"
    else
        warn "skipping parser builds: need tree-sitter-cli and a C compiler"
    fi
    say "Plugin bootstrap done. LSP servers (mason) install on your first interactive launch."
}

maybe_bootstrap() {
    if ! have nvim || ! nvim_version_ok; then
        say ""
        say "Skipping plugin bootstrap: nvim >= $MIN_NVIM_MAJOR.$MIN_NVIM_MINOR not found."
        return 0
    fi
    case "$BOOTSTRAP" in
        1) bootstrap_plugins ;;
        0) say "Skipping plugin bootstrap (run nvim once to install plugins)." ;;
        *)
            # When piped through curl, stdin is the script, so ask on the terminal.
            local reply=""
            if [ -t 0 ]; then
                printf '\nBootstrap plugins now with a headless nvim run? [y/N] '
                read -r reply || reply=""
            elif [ -r /dev/tty ] && { : </dev/tty; } 2>/dev/null; then
                printf '\nBootstrap plugins now with a headless nvim run? [y/N] ' >/dev/tty
                read -r reply </dev/tty || reply=""
            else
                say ""
                say "Non-interactive: skipping plugin bootstrap (pass --bootstrap to enable)."
                return 0
            fi
            case "$reply" in
                y|Y|yes|YES) bootstrap_plugins ;;
                *) say "Skipping plugin bootstrap (run nvim once to install plugins)." ;;
            esac
            ;;
    esac
}

# ------------------------------------------------------------------------ main

main() {
    local repo
    if ! have git; then
        warn "missing: git (required)"
        hint git git git git
        exit 1
    fi
    repo="$(find_local_repo)"
    if [ -n "$repo" ]; then
        say "Using local checkout: $repo"
    else
        ensure_remote_clone
        repo="$REPO_DIR"
    fi

    link_config "$repo"

    # init.lua points undodir here and nvim does not create it.
    mkdir -p "$HOME/.vim/undodir"

    check_deps
    maybe_bootstrap

    say ""
    say "Done. Update later with: git -C \"$repo\" pull"
}

main
