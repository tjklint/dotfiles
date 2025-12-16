
# === Cursor AI Toggle Commands (No Comments, jq-Safe) ===

cursorify() {
  local config_path="$HOME/Library/Application Support/Cursor/User/settings.json"
  [[ ! -f "$config_path" ]] && { echo "⚠️ Cursor settings not found at: $config_path"; return 1 }

  jq '. + {
    "cursor.enableChat": true,
    "cursor.enableAutocomplete": true,
    "cursor.copilot.enable": true,
    "cursor.editor.experimental.editorChat.enabled": true,
    "cursor.experimental.autocomplete": true,
    "cursor.enableAutocompleteProvider": true,
    "cursor.completions.enabled": true,
    "workbench.experimental.chat.enabled": true,

    "editor.inlineSuggest.enabled": true,
    "editor.quickSuggestions": {"other": true, "comments": true, "strings": true},
    "editor.suggest.showWords": true,
    "editor.suggest.showSnippets": true,
    "editor.suggest.showClasses": true,
    "editor.suggest.showFunctions": true,
    "editor.suggest.showVariables": true,
    "editor.suggest.showKeywords": true,
    "editor.suggest.showModules": true,
    "editor.suggest.showProperties": true,
    "editor.suggest.showEvents": true,
    "editor.suggest.showConstructors": true,
    "editor.suggest.showInterfaces": true,
    "editor.suggest.showMethods": true,
    "editor.suggest.showValues": true,
    "editor.suggest.showUnits": true,
    "editor.suggest.showColors": true,
    "editor.suggest.showCustomcolors": true,
    "editor.suggest.showTypeParameters": true,
    "editor.suggest.showDeprecated": true,
    "editor.suggest.showUsers": true,
    "editor.suggest.showFiles": true,
    "editor.suggest.showReferences": true,
    "editor.suggest.preview": true,
    "editor.parameterHints.enabled": true,
    "editor.hover.enabled": true,

    "typescript.suggest.enabled": true,
    "javascript.suggest.enabled": true,
    "html.suggest.enabled": true,
    "css.suggest.enabled": true,
    "json.suggest.enabled": true,
    "markdown.suggest.enabled": true,

    "github.copilot.enable": true,
    "github.copilot.inlineSuggest.enable": true,
    "github.copilot.chat.enabled": true,

    "editor.tabCompletion": "on",
    "editor.wordBasedSuggestions": true,
    "editor.acceptSuggestionOnEnter": "on",
    "editor.acceptSuggestionOnCommitCharacter": true,
    "editor.suggestOnTriggerCharacters": true,
    "editor.autoClosingBrackets": "always",
    "editor.autoClosingQuotes": "always",
    "editor.autoSurround": "languageDefined",
    "editor.autoIndent": "full",
    "editor.bracketPairColorization.enabled": true,
    "editor.hover.sticky": true
  }' "$config_path" > "$config_path.tmp" && mv "$config_path.tmp" "$config_path"

  echo "✨ Cursorify: ALL AI & completions re-enabled!"
}

uncursorify() {
  local config_path="$HOME/Library/Application Support/Cursor/User/settings.json"
  [[ ! -f "$config_path" ]] && { echo "⚠️ Cursor settings not found at: $config_path"; return 1 }

  jq '. + {
    "cursor.enableChat": false,
    "cursor.enableAutocomplete": false,
    "cursor.copilot.enable": false,
    "cursor.editor.experimental.editorChat.enabled": false,
    "cursor.experimental.autocomplete": false,
    "cursor.enableAutocompleteProvider": false,
    "cursor.completions.enabled": false,
    "workbench.experimental.chat.enabled": false,

    "editor.inlineSuggest.enabled": false,
    "editor.quickSuggestions": {"other": false, "comments": false, "strings": false},
    "editor.suggest.showWords": false,
    "editor.suggest.showSnippets": false,
    "editor.suggest.showClasses": false,
    "editor.suggest.showFunctions": false,
    "editor.suggest.showVariables": false,
    "editor.suggest.showKeywords": false,
    "editor.suggest.showModules": false,
    "editor.suggest.showProperties": false,
    "editor.suggest.showEvents": false,
    "editor.suggest.showConstructors": false,
    "editor.suggest.showInterfaces": false,
    "editor.suggest.showMethods": false,
    "editor.suggest.showValues": false,
    "editor.suggest.showUnits": false,
    "editor.suggest.showColors": false,
    "editor.suggest.showCustomcolors": false,
    "editor.suggest.showTypeParameters": false,
    "editor.suggest.showDeprecated": false,
    "editor.suggest.showUsers": false,
    "editor.suggest.showFiles": false,
    "editor.suggest.showReferences": false,
    "editor.suggest.preview": false,
    "editor.parameterHints.enabled": false,
    "editor.hover.enabled": false,

    "typescript.suggest.enabled": false,
    "javascript.suggest.enabled": false,
    "html.suggest.enabled": false,
    "css.suggest.enabled": false,
    "json.suggest.enabled": false,
    "markdown.suggest.enabled": false,

    "github.copilot.enable": false,
    "github.copilot.inlineSuggest.enable": false,
    "github.copilot.chat.enabled": false,

    "editor.tabCompletion": "off",
    "editor.wordBasedSuggestions": false,
    "editor.acceptSuggestionOnEnter": "off",
    "editor.acceptSuggestionOnCommitCharacter": false,
    "editor.suggestOnTriggerCharacters": false,
    "editor.autoClosingBrackets": "never",
    "editor.autoClosingQuotes": "never",
    "editor.autoSurround": "never",
    "editor.autoIndent": "none",
    "editor.bracketPairColorization.enabled": false,
    "editor.hover.sticky": false,
    "editor.quickSuggestionsDelay": 999999
  }' "$config_path" > "$config_path.tmp" && mv "$config_path.tmp" "$config_path"

  echo "🙈 Uncursorify: ALL AI, completions, and suggestions disabled — nothing remains."
}

# === End Cursor AI Toggle Commands ===

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

#for file in ~/.zshrc.d/*.zsh; do
#  [ -r "$file" ] && source "$file"
#done


# --- Oh My Zsh ---

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

macchina

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/tj/.bun/_bun" ] && source "/Users/tj/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Antigravity
export PATH="/Users/tj/.antigravity/antigravity/bin:$PATH"
