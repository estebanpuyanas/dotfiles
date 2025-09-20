# ── Terminal Color Support ───────────────────────────────────────────
export TERM=xterm-256color
export COLORTERM="truecolor"

# ── Restore system path for clean shells ─────────────────────────────
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$PATH"

# Disable Oh My Zsh compfix prompt
ZSH_DISABLE_COMPFIX=true

# Set up secure completions
autoload -Uz compinit
compinit #(use this to silently ignore insecure directories/files warning)

# Case insensitive completions with partial regex matching:
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 

# Menu selection styling in case of multiple matches: 
zstyle ':completion:*' menu-select

# ── Oh My Zsh base setup ─────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# ── 1) rbenv ─────────────────────────────────────────────────────────
# Commenting out since not using ruby VM for development in linux.
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"

# ── 2) User binaries ─────────────────────────────────────────────────
export PATH="$HOME/bin:$PATH"

# ── 3) Deduplicate $PATH ─────────────────────────────────────────────
typeset -U PATH

# ── 4) nvm ───────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ── 5) completions (rbenv) ───────────────────────────────────────────
# Commenting since not using Ruby VM for development in Linux
# fpath=("$HOME/.rbenv/completions" $fpath)

# ── 6) Oh My Zsh plugin setup ────────────────────────────────────────
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ── 7) Aliases ───────────────────────────────────────────────────────
alias vim='nvim'
alias vi='nvim'
alias nvconf='nvim ~/.config/nvim'
alias zconf='nvim ~/.zshrc'
alias p='cd ~/Desktop/projects'
alias d='cd ~/Desktop'
alias ..='cd ..'
alias ~='cd ~'
alias xx='clear'
alias zs='source ~/.zshrc'
alias la='ls -a'
alias tk='tmux kill-server'
alias dfs='cd ~/dotfiles'

# npm stuff for class: 
alias lint='npm run lint'
alias styker='npm run stryker'
alias dev='npm run dev'
alias install='npm install'


# ── 8) Customizations ────────────────────────────────────────────────
# Auto-start tmux unless inside tmux, SSH, or VS Code terminal
if command -v tmux &> /dev/null && \
   [ -z "$TMUX" ] && \
   [ -z "$SSH_CONNECTION" ] && \
   [ "$TERM_PROGRAM" != "vscode" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi

# ── 9) (Zsh Highligting)────────────────────────────────────────────────
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ── 10) (OPAM [OCaml Package Management])────────────────────────────────────────────────

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/estebanpuyanas/.opam/opam-init/init.zsh' ]] || source '/home/estebanpuyanas/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
