# Main zsh configuration file
# Sources modular configuration files from zsh-config/ in a deliberate order:
# oh-my-zsh first so our aliases/functions can override its defaults.

ZSH_CONFIG_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)/zsh-config"

# 1. Oh My Zsh (must load before aliases so our aliases win)
source "$ZSH_CONFIG_DIR/oh-my-zsh.zsh"

# 2. Everything else (aliases override OMZ defaults)
for file in "$ZSH_CONFIG_DIR"/*.zsh; do
  [ "$file" = "$ZSH_CONFIG_DIR/oh-my-zsh.zsh" ] && continue
  [ -r "$file" ] && source "$file"
done

macchina
