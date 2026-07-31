# Main zsh configuration file
# Sources modular configuration files from zsh-config/ in a deliberate order:
# oh-my-zsh first so our aliases/functions can override its defaults.

ZSH_CONFIG_DIR="$HOME/dotfiles/zsh-config"

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
export PNPM_HOME="/home/tj/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/tj/.bun/_bun" ] && source "/home/tj/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
