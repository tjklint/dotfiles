#!/bin/bash
set -e

echo "🚀 Setting up dotfiles environment..."

# Detect OS and package manager
detect_package_manager() {
  if command -v pacman &> /dev/null; then
    echo "pacman"
  elif command -v brew &> /dev/null; then
    echo "brew"
  elif command -v apt &> /dev/null; then
    echo "apt"
  elif command -v dnf &> /dev/null; then
    echo "dnf"
  else
    echo "unknown"
  fi
}

PM=$(detect_package_manager)

if [ "$PM" = "unknown" ]; then
  echo "❌ Could not detect package manager. Supported: pacman, brew, apt, dnf"
  exit 1
fi

echo "📦 Detected package manager: $PM"

# Install system packages based on package manager
install_packages() {
  case "$PM" in
    pacman)
      echo "Installing packages via pacman..."
      sudo pacman -Syu --noconfirm
      sudo pacman -S --noconfirm \
        git code ghostty \
        nvm pnpm tmux \
        fzf ripgrep jq eza bat qrencode lsof
      ;;
    brew)
      echo "Installing packages via brew..."
      brew update
      brew install \
        git visual-studio-code ghostty \
        nvm pnpm tmux \
        fzf ripgrep jq eza bat qrencode lsof gh
      ;;
    apt)
      echo "Installing packages via apt..."
      sudo apt update
      sudo apt install -y \
        git code ghostty \
        nodejs npm tmux \
        fzf ripgrep jq eza bat qrencode lsof gh
      ;;
    dnf)
      echo "Installing packages via dnf..."
      sudo dnf install -y \
        git code ghostty \
        nodejs npm tmux \
        fzf ripgrep jq eza bat qrencode lsof gh
      ;;
  esac
}

# Install nvm (if not already installed)
install_nvm() {
  if [ -d "$HOME/.nvm" ]; then
    echo "✓ nvm already installed"
  else
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install node
    nvm use node
    echo "✓ nvm installed and node configured"
  fi
}

# Install bun (if not already installed)
install_bun() {
  if command -v bun &> /dev/null; then
    echo "✓ bun already installed"
  else
    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    echo "✓ bun installed"
  fi
}

# Install oh-my-zsh (if not already installed)
install_omz() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✓ oh-my-zsh already installed"
  else
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✓ oh-my-zsh installed"
  fi
}

# Install zoxide (if not already installed)
install_zoxide() {
  if command -v zoxide &> /dev/null; then
    echo "✓ zoxide already installed"
  else
    echo "Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    echo "✓ zoxide installed"
  fi
}

# Install fastfetch (if not already installed)
install_fastfetch() {
  if command -v fastfetch &> /dev/null; then
    echo "✓ fastfetch already installed"
  else
    echo "Installing fastfetch..."
    case "$PM" in
      pacman) sudo pacman -S --noconfirm fastfetch ;;
      brew)   brew install fastfetch ;;
      apt)    sudo apt install -y fastfetch ;;
      dnf)    sudo dnf install -y fastfetch ;;
    esac
    echo "✓ fastfetch installed"
  fi
}

# Install GitHub CLI (if not already installed and not using brew)
install_gh() {
  if command -v gh &> /dev/null; then
    echo "✓ GitHub CLI already installed"
  else
    echo "Installing GitHub CLI..."
    case "$PM" in
      pacman)
        sudo pacman -S --noconfirm github-cli
        ;;
      apt)
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install -y gh
        ;;
      dnf)
        sudo dnf install -y gh
        ;;
    esac
    echo "✓ GitHub CLI installed"
  fi
}

# Install zsh plugins (autosuggestions + syntax highlighting)
install_zsh_plugins() {
  echo "Installing zsh plugins..."
  PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
  mkdir -p "$PLUGINS_DIR"

  if [ -d "$PLUGINS_DIR/zsh-autosuggestions/.git" ]; then
    echo "✓ zsh-autosuggestions already installed"
  else
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
    echo "✓ zsh-autosuggestions installed"
  fi

  if [ -d "$PLUGINS_DIR/zsh-syntax-highlighting/.git" ]; then
    echo "✓ zsh-syntax-highlighting already installed"
  else
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGINS_DIR/zsh-syntax-highlighting"
    echo "✓ zsh-syntax-highlighting installed"
  fi
}

# Link config files into place
link_configs() {
  echo "🔗 Linking config files..."

  # zsh
  ln -sfn "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"

  # git
  ln -sfn "$HOME/dotfiles/.gitconfig" "$HOME/.gitconfig"

  # opencode
  mkdir -p "$HOME/.config/opencode"
  ln -sfn "$HOME/dotfiles/opencode.jsonc" "$HOME/.config/opencode/opencode.jsonc"

  # Ghostty
  mkdir -p "$HOME/.config/ghostty"
  ln -sfn "$HOME/dotfiles/config.ghostty" "$HOME/.config/ghostty/config.ghostty"
  ln -sfn "$HOME/dotfiles/tabs.css" "$HOME/.config/ghostty/tabs.css"

  echo "✓ Config files linked"
}

# Run installations
install_packages
install_nvm
install_bun
install_omz
install_zoxide
install_fastfetch
install_gh
install_zsh_plugins
link_configs

echo ""
echo "✨ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Authenticate with GitHub: gh auth login"
echo "  3. Happy coding! 🎉"
