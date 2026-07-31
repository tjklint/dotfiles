#!/bin/bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/tjklint/dotfiles.git}"

if [ -d "$DOTFILES_DIR/.git" ]; then
  echo "✓ Dotfiles already cloned at $DOTFILES_DIR — pulling latest"
  git -C "$DOTFILES_DIR" pull --ff-only
else
  echo "📦 Cloning dotfiles to $DOTFILES_DIR..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

exec "$DOTFILES_DIR/setup.sh"
