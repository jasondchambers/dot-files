# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles for macOS, Omarchy (Arch Linux), and Linux Mint. Everything is installed via symlinks — no files are copied. Re-running `install.sh` is always safe (idempotent; existing configs are backed up with `.bak`).

## Install Commands

```sh
./install.sh                          # install all components
./install.sh zsh nvim tmux           # install specific components
./configure.sh                        # one-time macOS setup (SSH key, scroll direction)
```

Valid component names: `packages utils tmux alacritty zsh starship nvim git lazygit hypr hammerspoon karabiner uv fzf_git`

## Architecture

### OS Detection & Per-OS Variants

`install.sh` auto-detects the OS (`omarchy` / `linuxmint` / `macos`) and symlinks the correct variant file. Files with OS suffixes follow the pattern:

- `zsh/zshrc.omarchy`, `zsh/zshrc.linuxmint`, `zsh/zshrc.macOS`
- `alacritty/alacritty.toml.omarchy`, `alacritty.toml.linuxmint`, `alacritty.toml.macos`

The installer creates `alacritty/alacritty.toml` as a symlink inside the repo dir pointing to the correct variant.

### Component → Target Mapping

| Component | Symlink target |
|-----------|---------------|
| tmux | `~/.tmux.conf` |
| alacritty | `~/.config/alacritty/` (whole dir) |
| zsh | `~/.zshrc` |
| starship | `~/.config/starship.toml` |
| nvim | `~/.config/nvim/` (whole dir) |
| git | `~/.config/git/config` |
| lazygit | `~/.config/lazygit/` |
| hypr | `~/.config/hypr/bindings.conf` only |
| hammerspoon | `~/.hammerspoon/` (macOS only) |
| karabiner | `~/.config/karabiner/karabiner.json` (macOS only) |

### Neovim Structure

Neovim config lives in `nvim/` and uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management. Entry point is `nvim/init.lua`.

```
nvim/lua/jasondchambers/
├── core/
│   ├── options.lua       # vim options
│   └── keymaps.lua       # global keymaps (leader = Space)
├── lazy.lua              # lazy.nvim bootstrap
└── plugins/              # one file per plugin
    ├── lsp.lua           # Mason + LSP (pyright, ruff, bashls)
    ├── telescope.lua     # fuzzy finder
    ├── nvim-tree.lua     # file explorer
    ├── theme.lua         # active theme (NOT committed — see below)
    ├── theme.lua.default # default theme template (tokyonight)
    └── ...
```

**Theme management:** `theme.lua` is generated from `theme.lua.default` on first install (if absent). It is intentionally not overwritten on re-install, allowing per-machine theme customization without affecting git state. When Omarchy switches themes, it may write its own `theme.lua`.

**LSP servers** (auto-installed via Mason): `pyright` (Python types), `ruff` (Python linting/formatting), `bashls` (shell). Also installs `debugpy` for Python DAP debugging.

### zshrc Pattern

The zshrc files use zsh `def` functions (not `function` keyword) as a namespacing convention — each concern is wrapped in a `def configure_X()` block and called at the bottom of the file. chpwd hooks auto-activate Python venvs and detect Doppler configs on directory change.

### Hyprland Bindings

`hypr/bindings.conf` is an *overlay* file — it only contains custom bindings that extend/override Omarchy's defaults. It does **not** replace the full Omarchy Hyprland config.

### Hammerspoon (macOS)

Provides app-launch keybindings on macOS that mirror the Hyprland bindings in `hypr/bindings.conf`, maintaining cross-platform consistency.

## Skills

Use the `omarchy` skill when making any changes to Hyprland, Waybar, terminal, or other desktop/compositor config. This skill provides specialized knowledge about the Omarchy Linux desktop setup.
