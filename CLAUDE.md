# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles for macOS and CachyOS. Everything is installed via symlinks — no files are copied (sole exception: `sddm`, see below). Re-running `install.sh` is always safe (idempotent; existing configs are backed up with `.bak`).

## Install Commands

```sh
./install.sh                          # install all default components
./install.sh zsh nvim                 # install specific components
./configure.sh                        # one-time setup (SSH key, macOS scroll direction)
```

Default components (run when no args are given, in this order): `packages utils ghostty zsh starship nvim git lazygit hypr hammerspoon karabiner uv tv fzf_git eza television rofi applications sddm language_servers clang`

`hyprmod` is also a valid component (clones [BlueManCZ/hyprmod](https://github.com/BlueManCZ/hyprmod) to `~/repos/hyprmod`) but is **not** part of the default set — install it explicitly with `./install.sh hyprmod`.

## Architecture

### OS Detection & Per-OS Variants

`install.sh` auto-detects the OS from `/etc/os-release` (`cachyos`) or `uname` (`macos`, i.e. Darwin). Files with OS suffixes follow the pattern:

- `zsh/zshrc.cachyos`, `zsh/zshrc.macOS`
- `ghostty/config.cachyos`, `config.macos`

The installer symlinks `ghostty/config` inside the repo dir to the correct variant (gitignored, since it's machine-generated). `zshrc.linuxmint` also exists in the repo but is dead weight — `detect_os` has no `linuxmint` case, so the installer never selects it.

### Component → Target Mapping

| Component | Symlink target |
|-----------|---------------|
| packages | `Brewfile` via `brew bundle` (macOS) / `packages/pkglist.txt` + `packages/aur.txt` via `paru` (CachyOS) |
| utils | `~/repos/utils` (git-cloned, not symlinked) |
| ghostty | `~/.config/ghostty/` (whole dir; `config` → OS variant) |
| zsh | `~/.zshrc` |
| starship | `~/.config/starship.toml` |
| nvim | `~/.config/nvim/` (whole dir; also downloads the Neovim 0.12 binary on CachyOS) |
| git | `~/.config/git/config` |
| lazygit | `~/.config/lazygit/` (macOS: `~/Library/Application Support/lazygit/config.yml`) |
| hypr | `~/.config/hypr/` (whole dir — CachyOS only) |
| rofi | `~/.config/rofi/` (CachyOS only) |
| applications | `~/.local/share/applications/*.desktop` (launcher entries for Lock Screen / Logout / Restart / Shutdown, symlinked file-by-file so the DMS Spotlight launcher (and rofi's drun) lists them — CachyOS only) |
| sddm | `/etc/sddm.conf.d/theme.conf` — **copied with `sudo`, not symlinked** (the greeter runs as the `sddm` user and can't read `~`, which is mode 700); also installs the `sddm-astronaut-theme` AUR package (CachyOS only) |
| hammerspoon | `~/.hammerspoon/` (macOS only) |
| karabiner | `~/.config/karabiner/` (whole dir — Karabiner rewrites `karabiner.json` on save, which would break a file symlink; macOS only) |
| uv | installs the `uv` binary (astral.sh installer) |
| tv | installs the `television` binary |
| fzf_git | clones fzf-git.sh to `~/repos/fzf-git.sh` |
| eza | `~/.config/eza/` (macOS: `~/Library/Application Support/eza/`) |
| television | `~/.config/television/cable/*.toml` (custom channels, symlinked file-by-file) |
| language_servers | installs `bash-language-server` (pacman, CachyOS only), `basedpyright` (`uv tool install`), `typescript-language-server` (`npm install -g`) |
| clang | `~/.clang-format` + clangd's global config (`~/.config/clangd/config.yaml`, macOS: `~/Library/Preferences/clangd/config.yaml`) |

`waybar/` also exists in the repo (`config.jsonc`, `style.css`, `power_menu.xml`, `wifi-menu.sh`), but it is **not** a symlinked install.sh component and is no longer started — DankMaterialShell replaced it (see "Desktop Shell" below). `rofi/` is still installed but no longer bound to SUPER + SPACE.

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

The whole `hypr/` directory is symlinked to `~/.config/hypr/` (not just bindings, as in older setups). The config is written in Hyprland's Lua format: `hypr/hyprland.lua` is the full config (CachyOS/omarchy-generated base, customized) and `require`s `hypr/tiling.lua`, `hypr/bindings.lua`, and `hypr/hyprland-gui.lua` (HyprMod-managed settings — note HyprMod may still write the old hyprlang format). `hypr/bindings.lua` is the file to edit for custom keybindings — it's an overlay of the omarchy defaults, not a replacement; window bindings (close, fullscreen, maximize) live in `hypr/tiling.lua`. `hypridle.conf` and `hyprlock.conf` remain in hyprlang format (now unused — see below), and `hypr/old-conf/` keeps the pre-Lua `.conf` files for reference only.

### Desktop Shell (DankMaterialShell)

On CachyOS the bar, launcher, notifications, clipboard history, lock screen and idle handling all come from [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) (DMS, the `dms-shell` package, built on Quickshell). It replaced Waybar, Rofi, hyprlock and hypridle.

- `hypr/hyprland.lua` autostarts `dms run` and `wl-paste --watch cliphist store`, sets `menu` to `dms ipc call spotlight toggle` (SUPER + SPACE), and has a `dms-no-anim` layer rule matching `^dms:.*` (the bar's namespace is `dms:bar`).
- Locking goes through `dms ipc call lock lock` — both the `CTRL + ALT + Q` binding in `hypr/bindings.lua` and `applications/lock-screen.desktop`.
- The `hypridle` systemd user service is **disabled**; idle lock / monitor-off / lock-before-suspend are set in the DMS settings GUI (Power & Sleep → Idle Settings), which stores them under `~/.config/DankMaterialShell/` — not in this repo.
- DMS generates `hypr/dms/*.lua` and `ghostty/themes/dankcolors` (Matugen theming). They land in the repo because those dirs are symlinked, so they're gitignored; `hyprland.lua` deliberately does **not** `require("dms.*")`.
- The `fit-floats-workspace-1` window rule's `monitor_h-104` assumes the 64px DMS bar.
- Other actions are available via `dms ipc call <target> <fn>` (e.g. `audio increment 3`, `brightness increment 5`, `clipboard toggle`, `notifications toggle`).
- To roll back: restore `waybar` / `rofi -show drun` / `hyprlock` in those places and `systemctl --user enable --now hypridle`; the old configs and packages are still in place.

### Hammerspoon (macOS)

Provides app-launch and window-management keybindings on macOS that mirror the Hyprland bindings in `hypr/bindings.lua` and `hypr/tiling.lua`, maintaining cross-platform consistency. Hammerspoon binds `alt` where Hyprland uses SUPER (and `alt`+`cmd` for SUPER + ALT). Karabiner swaps left Cmd/Option on the Razer Ornata Chroma only (`device_if` on vendor 5426 / product 542), so on that keyboard the physical SUPER key sends Option and the bindings are identical across CachyOS and macOS; on an Apple keyboard, Option stands in for SUPER.

## Skills

Use the `omarchy` skill when making any changes to Hyprland, Waybar, terminal, or other desktop/compositor config on CachyOS. This skill provides specialized knowledge about the Hyprland desktop setup.
