# Dotfiles

Personal dotfiles for macOS and Linux (Arch/Ubuntu/Fedora). Configuration lives
flat at the repo root and is symlinked into place by `setup.sh`, so edits in the
repo apply instantly.

## Quick start

```sh
curl -fsSL https://raw.githubusercontent.com/tjklint/dotfiles/master/install.sh | bash
```

Or clone and run manually:

```sh
git clone https://github.com/tjklint/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

`setup.sh` installs packages, then symlinks the configs below. It only needs to
run once per fresh machine; afterwards edits apply live through the symlinks.

## What's configured

| File                | Installed by setup.sh as                          |
| ------------------- | ------------------------------------------------- |
| `.zshrc`            | `~/.zshrc`                                        |
| `.gitconfig`        | `~/.gitconfig`                                    |
| `opencode.jsonc`    | `~/.config/opencode/opencode.jsonc`               |
| `fastfetch.jsonc`   | `~/.config/fastfetch/config.jsonc`                |
| `config.ghostty`    | `~/.config/ghostty/config.ghostty`                |
| `tabs.css`          | `~/.config/ghostty/tabs.css`                      |
| `*.zsh` modules     | sourced from `~/.zshrc`                           |

To override the clone location, set `DOTFILES_DIR` before running:

```sh
DOTFILES_DIR=/opt/dotfiles curl -fsSL .../install.sh | bash
```

## Per-machine overrides

`config.ghostty` ends with a `config-file = ?local.conf` line, so drop a
`~/.config/ghostty/local.conf` on any machine to override theme, fonts, or
keybinds without forking the repo.

On apt/dnf systems `setup.sh` skips `code` and `ghostty` (not in default repos)
and prints pointers for installing them manually.
