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

# zoxide (smart cd)
eval "$(zoxide init zsh)"
alias cd="z"

# tmux
alias t="tmux attach || tmux new -s main"

