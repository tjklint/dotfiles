# Main zsh configuration file
# Sources modular configuration files from the repo root in a deliberate order:
# oh-my-zsh first so our aliases/functions can override its defaults.

ZSH_CONFIG_DIR="$HOME/dotfiles"

# 1. Oh My Zsh (must load before aliases so our aliases win)
source "$ZSH_CONFIG_DIR/oh-my-zsh.zsh"

# 2. Everything else (aliases override OMZ defaults)
for file in "$ZSH_CONFIG_DIR"/*.zsh; do
  [ "$file" = "$ZSH_CONFIG_DIR/oh-my-zsh.zsh" ] && continue
  [ -r "$file" ] && source "$file"
done

fastfetch

# zoxide (smart cd) — must be last so all PATH/hook mutations are done.
eval "$(zoxide init zsh)"
alias cd="z"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Homebrew libpq is keg-only, so psql and friends only resolve if added to PATH.
[ -d "/opt/homebrew/opt/libpq/bin" ] && export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
