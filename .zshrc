# Main zsh configuration file
# This file sources modular configuration files from zsh-config/

# Get the directory where this .zshrc file is located
ZSH_CONFIG_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)/zsh-config"

# Source all configuration files from zsh-config directory
for file in "$ZSH_CONFIG_DIR"/*.zsh; do
  [ -r "$file" ] && source "$file"
done

macchina
