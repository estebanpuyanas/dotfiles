# ── Terminal Color Support ───────────────────────────────────────────
export TERM=xterm-256color
export COLORTERM="truecolor"

# ── Restore system path for clean shells ─────────────────────────────
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$PATH"

# Disable Oh My Zsh compfix prompt
ZSH_DISABLE_COMPFIX=true

# Set up secure completions
autoload -Uz compinit
compinit -i

# ── Oh My Zsh base setup ─────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# ── 1) rbenv ─────────────────────────────────────────────────────────
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# ── 2) User binaries ─────────────────────────────────────────────────
export PATH="$HOME/bin:$PATH"

# ── 3) Deduplicate $PATH ─────────────────────────────────────────────
typeset -U PATH

# ── 4) nvm ───────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ── 5) completions (rbenv) ───────────────────────────────────────────
fpath=("$HOME/.rbenv/completions" $fpath)

# ── 6) Oh My Zsh plugin setup ────────────────────────────────────────
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ── 7) Aliases ───────────────────────────────────────────────────────
alias vim='nvim'
alias vi='nvim'
alias nvconf='nvim ~/.config/nvim'
alias zconf='nvim ~/.zshrc'
alias p='cd ~/desktop/projects'
alias d='cd ~/Desktop'
alias ..='cd ..'
alias ~='cd ~'
alias xx='clear'
alias zs='source ~/.zshrc'
alias la='ls -a'
alias tk='tmux kill-server'

# ── 8) Customizations ────────────────────────────────────────────────
# Auto-start tmux unless inside tmux, SSH, or VS Code terminal
if command -v tmux &> /dev/null && \
   [ -z "$TMUX" ] && \
   [ -z "$SSH_CONNECTION" ] && \
   [ "$TERM_PROGRAM" != "vscode" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi
