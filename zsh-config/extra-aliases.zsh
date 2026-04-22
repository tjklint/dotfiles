# --- Extra Aliases ---

# Git shortcuts
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"
alias glog="git log --oneline --graph --decorate --all" 
alias fap="git fetch --all --prune"

# Quick edits
alias zshrc="code ~/dotfiles/.zshrc"
alias zshconfig="code ~/dotfiles/zsh-config"

# System
alias reload="source ~/.zshrc"
alias path='echo $PATH | tr -s ":" "\n"'

# Find files
alias ff="find . -type f -name"
alias fd="find . -type d -name"

# Process management
alias psg="ps aux | grep -v grep | grep -i"

# Network
alias ping="ping -c 5"
alias ports="lsof -i -P -n | grep LISTEN"
# macOS specific (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
  alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
  alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
fi

