# Render a QR code in the terminal from args or piped stdin.
qr() {
  if ! command -v qrencode >/dev/null 2>&1; then
    echo "qr: 'qrencode' not found. Install: brew install qrencode" >&2
    return 1
  fi
  local input
  if [ $# -eq 0 ]; then
    if [ -t 0 ]; then
      echo "Usage: qr <text|url>   OR   echo <text> | qr" >&2
      return 1
    fi
    input=$(cat)
  else
    input="$*"
  fi
  qrencode -t ANSI256 -- "$input"
}

# Show GitHub stats for the repo the current directory belongs to.
ghstalk() {
  if ! command -v gh >/dev/null 2>&1; then
    echo "ghstalk: 'gh' CLI not found. Install: brew install gh" >&2
    return 1
  fi
  if ! command -v jq >/dev/null 2>&1; then
    echo "ghstalk: 'jq' not found. Install: brew install jq" >&2
    return 1
  fi
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "ghstalk: not inside a git repository" >&2
    return 1
  fi

  local remote slug
  remote=$(git remote get-url origin 2>/dev/null) || {
    echo "ghstalk: no 'origin' remote configured" >&2
    return 1
  }
  slug="$remote"
  slug="${slug#git@github.com:}"
  slug="${slug#ssh://git@github.com/}"
  slug="${slug#https://github.com/}"
  slug="${slug#http://github.com/}"
  slug="${slug%.git}"
  slug="${slug%/}"
  if [[ "$slug" != */* || "$slug" == "$remote" ]]; then
    echo "ghstalk: could not parse github owner/repo from: $remote" >&2
    return 1
  fi

  echo "📦 $slug"
  local repo_json
  repo_json=$(gh api "repos/$slug" 2>/dev/null) || {
    echo "ghstalk: failed to fetch repo data (private or rate-limited?)" >&2
    return 1
  }

  local description stars forks watchers issues lang created pushed license default_branch homepage topics size_kb
  description=$(echo "$repo_json"   | jq -r '.description // "—"')
  stars=$(echo "$repo_json"         | jq -r '.stargazers_count')
  forks=$(echo "$repo_json"         | jq -r '.forks_count')
  watchers=$(echo "$repo_json"      | jq -r '.subscribers_count')
  issues=$(echo "$repo_json"        | jq -r '.open_issues_count')
  lang=$(echo "$repo_json"          | jq -r '.language // "—"')
  created=$(echo "$repo_json"       | jq -r '.created_at'  | cut -d'T' -f1)
  pushed=$(echo "$repo_json"        | jq -r '.pushed_at'   | cut -d'T' -f1)
  license=$(echo "$repo_json"       | jq -r '.license.spdx_id // "none"')
  default_branch=$(echo "$repo_json"| jq -r '.default_branch')
  homepage=$(echo "$repo_json"      | jq -r '.homepage // empty')
  topics=$(echo "$repo_json"        | jq -r '.topics | join(", ")')
  size_kb=$(echo "$repo_json"       | jq -r '.size')

  echo "   $description"
  [ -n "$homepage" ] && echo "   🌐 $homepage"
  [ -n "$topics"   ] && echo "   🏷  $topics"
  echo ""
  printf "   ⭐ %s   🍴 %s   👀 %s   🐛 %s open issues\n" "$stars" "$forks" "$watchers" "$issues"
  printf "   📅 Created %s · Last push %s\n" "$created" "$pushed"
  printf "   🌿 %s · 📜 %s · 💬 %s · 💾 %s KB\n" "$default_branch" "$license" "$lang" "$size_kb"

  local latest_release
  latest_release=$(gh api "repos/$slug/releases/latest" 2>/dev/null \
    | jq -r 'select(.tag_name) | "\(.tag_name) (\(.published_at | split("T")[0]))"')
  [ -n "$latest_release" ] && printf "   🚀 Latest release: %s\n" "$latest_release"

  echo ""
  echo "👥 Top contributors:"
  gh api "repos/$slug/contributors?per_page=5" 2>/dev/null \
    | jq -r '.[] | "   \(.login) — \(.contributions) commits"'

  echo ""
  echo "💻 Language breakdown:"
  gh api "repos/$slug/languages" 2>/dev/null \
    | jq -r 'to_entries | sort_by(-.value) | .[:5]
             | (map(.value) | add) as $total
             | .[] | "   \(.key): \((.value * 100 / $total) | floor)%"'
}

# Kill processes listening on one or more ports.
destroy() {
  if [ $# -eq 0 ]; then
    echo "Usage: destroy <port> [port...]" >&2
    return 1
  fi
  local port pids
  for port in "$@"; do
    pids=$(lsof -ti :"$port")
    if [ -z "$pids" ]; then
      echo "destroy: no process listening on port $port"
      continue
    fi
    echo "destroy: killing port $port (pids: $(echo $pids | tr '\n' ' '))"
    echo "$pids" | xargs kill -9
  done
}

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

