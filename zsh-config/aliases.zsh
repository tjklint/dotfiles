# --- Aliases ---

# fzf (fuzzy finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bat (better cat)
alias cat="bat"

# eza (better ls)
alias ls="eza --icons --group-directories-first"
alias ll="eza -lh"
alias la="eza -lha"

# ripgrep (search)
alias rg="ripgrep"

# zoxide is initialized at the end of ../.zshrc (it must be last)

# tmux
alias t="tmux attach || tmux new -s main"

