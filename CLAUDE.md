# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles for macOS and CachyOS. Everything is installed via symlinks — no files are copied. Re-running `install.sh` is always safe (idempotent; existing configs are backed up with `.bak`).

## Install Commands

```sh
./install.sh                          # install all default components
./install.sh zsh nvim                 # install specific components
./configure.sh                        # one-time setup (SSH key, macOS scroll direction)
```

Default components (run when no args are given, in this order): `packages utils wezterm ghostty zsh starship nvim git lazygit hypr hammerspoon karabiner uv tv fzf_git eza television rofi language_servers clang`

`hyprmod` is also a valid component (clones [BlueManCZ/hyprmod](https://github.com/BlueManCZ/hyprmod) to `~/repos/hyprmod`) but is **not** part of the default set — install it explicitly with `./install.sh hyprmod`.

## Architecture

### OS Detection & Per-OS Variants

`install.sh` auto-detects the OS from `/etc/os-release` (`cachyos`) or `uname` (`macos`, i.e. Darwin). Files with OS suffixes follow the pattern:

- `zsh/zshrc.cachyos`, `zsh/zshrc.macOS`
- `wezterm/wezterm.lua.cachyos`, `wezterm.lua.macos`

The installer symlinks `wezterm/wezterm.lua` inside the repo dir to the correct variant (gitignored, since it's machine-generated). `zshrc.linuxmint` also exists in the repo but is dead weight — `detect_os` has no `linuxmint` case, so the installer never selects it.

### Component → Target Mapping

| Component | Symlink target |
|-----------|---------------|
| packages | `Brewfile` via `brew bundle` (macOS) / `packages/pkglist.txt` + `packages/aur.txt` via `paru` (CachyOS) |
| utils | `~/repos/utils` (git-cloned, not symlinked) |
| wezterm | `~/.config/wezterm/` (whole dir) |
| ghostty | `~/.config/ghostty/` (whole dir; `config` → OS variant) |
| zsh | `~/.zshrc` |
| starship | `~/.config/starship.toml` |
| nvim | `~/.config/nvim/` (whole dir; also downloads the Neovim 0.12 binary on CachyOS) |
| git | `~/.config/git/config` |
| lazygit | `~/.config/lazygit/` (macOS: `~/Library/Application Support/lazygit/config.yml`) |
| hypr | `~/.config/hypr/` (whole dir — CachyOS only) |
| rofi | `~/.config/rofi/` (CachyOS only) |
| hammerspoon | `~/.hammerspoon/` (macOS only) |
| karabiner | `~/.config/karabiner/karabiner.json` (macOS only) |
| uv | installs the `uv` binary (astral.sh installer) |
| tv | installs the `television` binary |
| fzf_git | clones fzf-git.sh to `~/repos/fzf-git.sh` |
| eza | `~/.config/eza/` (macOS: `~/Library/Application Support/eza/`) |
| television | `~/.config/television/cable/*.toml` (custom channels, symlinked file-by-file) |
| language_servers | installs `bash-language-server` (pacman, CachyOS only), `basedpyright` (`uv tool install`), `typescript-language-server` (`npm install -g`) |
| clang | `~/.clang-format` + clangd's global config (`~/.config/clangd/config.yaml`, macOS: `~/Library/Preferences/clangd/config.yaml`) |

`waybar/` also exists in the repo (`config.jsonc`, `style.css`, `power_menu.xml`, `wifi-menu.sh`) and is exec'd from `hypr/hyprland.conf`, but it is **not** currently a symlinked install.sh component.

### Neovim Structure

Neovim config is a single entry point plus one submodule — there is no plugin-per-file directory anymore:

```
nvim/
├── init.lua                                          # everything: options, plugins, keymaps, LSP
├── nvim-pack-lock.json                               # lockfile for vim.pack
└── lua/jasonchambers/alpha-custom-greeter/init.lua   # custom greeter used by alpha-nvim
```

- Targets Neovim 0.12+. Plugins are installed with the **native `vim.pack.add`** API (see `install_plugins()` in `init.lua`) — no lazy.nvim, no Mason.
- LSP servers use Neovim 0.12's **native `vim.lsp.enable()` / `vim.lsp.config()`** (see `configure_lsp()`) — again, no Mason. Each server binary must be installed manually via the OS package manager before it's enabled. `install.sh language_servers` only covers `bash-language-server`, `basedpyright`, and `typescript-language-server` — `lua_ls` (`lua-language-server`) and `clangd` (ships with the `clang` package) are enabled in `init.lua` but must be installed separately.
- Current servers: `basedpyright` (Python), `bashls` (Bash), `lua_ls` (Lua), `ts_ls` (JS/TS), `clangd` (C/C++).
- Colorscheme is hardcoded to `miniautumn` (from mini.nvim) in `init.lua` — there is no longer a per-machine `theme.lua` override file.

### zshrc Pattern

`zsh/zshrc.cachyos` and `zsh/zshrc.macOS` both organize config as `configure_*` functions called at the bottom of the file (see README.md's "Zsh" section for the full feature/alias tables). `zshrc.cachyos` additionally decorates most definitions with a leading `def` word, e.g. `def configure_history() { ... }`. This is not a zsh keyword — it's zsh's `name1 name2() { ... }` syntax, which defines a function under *every* listed name with the same body. `def` itself is never called; it's purely a stylistic (Python-esque) flourish and does no namespacing. `zshrc.macOS` does not use this pattern. `chpwd` hooks auto-activate Python venvs on directory change on both platforms; Homebrew setup and 1Password env loading (`op-env`) are macOS-only, `nvm` is CachyOS-only.

### Hyprland Config

The whole `hypr/` directory is symlinked to `~/.config/hypr/` (not just bindings, as in older setups). `hypr/hyprland.conf` is the full config (CachyOS/omarchy-generated base, customized) and `source`s `hypr/tiling.conf`, `hypr/bindings.conf`, and a local untracked `hyprland-gui.conf`. `hypr/bindings.conf` is still the file to edit for custom keybindings — it's an overlay of the omarchy defaults, not a replacement.

### Hammerspoon (macOS)

Provides app-launch keybindings on macOS that mirror the Hyprland bindings in `hypr/bindings.conf`, maintaining cross-platform consistency.

## Skills

Use the `omarchy` skill when making any changes to Hyprland, Waybar, terminal, or other desktop/compositor config on CachyOS. This skill provides specialized knowledge about the Hyprland desktop setup.
