export TERM=xterm-256color
export COLORTERM="truecolor"
# ── Oh My Zsh base setup ─────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

# Use random theme from custom candidates
ZSH_THEME="robbyrussell"

# ── 1) rbenv ─────────────────────────────────────────────────────────
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# ── 2) User binaries ─────────────────────────────────────────────────
export PATH="$HOME/bin:$PATH"

# ── 3) nvm ───────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ── 4) completions ───────────────────────────────────────────────────
FPATH="$HOME/.rbenv/completions:$FPATH"
# Avoid double compinit (oh-my-zsh may call it)
if ! type compinit &>/dev/null; then
  autoload -U compinit
  compinit
fi

# ── 5) asdf ──────────────────────────────────────────────────────────
export PATH="$(brew --prefix asdf)/libexec/bin:$PATH"
source "$(brew --prefix asdf)/libexec/asdf.sh"

# ── 6) Oh My Zsh plugin setup (minimal, or add your own) ─────────────
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

# ── 8) Any other customizations ──────────────────────────────────────
# Auto-start tmux unless inside tmux, SSH, or VS Code terminal
if command -v tmux &> /dev/null && \
   [ -z "$TMUX" ] && \
   [ -z "$SSH_CONNECTION" ] && \
   [ "$TERM_PROGRAM" != "vscode" ]; then

  tmux attach-session -t default || tmux new-session -s default
fi

