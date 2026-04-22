# Count lines of code across all git-tracked files in the current repo.
loc() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "loc: not inside a git repository" >&2
    return 1
  fi
  git ls-files -z | xargs -0 wc -l
}

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

