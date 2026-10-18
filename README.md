# dot-files

Personal dotfiles for macOS and CachyOS.

## Table of contents

- [Philosophy](#philosophy)
- [Quick start](#quick-start)
- [What gets installed](#what-gets-installed)
- [Selective install](#selective-install)
- [First-time macOS setup](#first-time-macos-setup)
- [Structure](#structure)
- [Zsh](#zsh)
  - [Shell Features](#shell-features)
  - [Directory Change Hooks (`chpwd`)](#directory-change-hooks-chpwd)
  - [Aliases](#aliases)
  - [macOS-only: 1Password Environment Loader](#macos-only-1password-environment-loader)
- [Notes](#notes)
- [Usage](#usage)
  - [Launching Applications](#launching-applications)
  - [Window Management](#window-management)
- [Ghostty](#ghostty)
- [Neovim](#neovim)
  - [Plugins](#plugins)
  - [LSP Servers](#lsp-servers)
  - [Keybindings](#keybindings)

## Philosophy

- Aesthetics (must look pretty)
- Consistency across platforms (macOS and CachyOS)
- Efficiency and speed - use the keyboard as much as possible
- Modern - e.g. [fd, rg, bat, zoxide, dysk, btop, eza] instead of/in addition to [find, grep, cat, cd, df, top, ls]

## Quick start

```sh
git clone https://github.com/jasondchambers/dot-files ~/repos/dot-files
cd ~/repos/dot-files
chmod +x install.sh
./install.sh
```

## What gets installed

| Component | Target | macOS | CachyOS |
|---|---|:---:|:---:|
| packages | Brewfile via `brew bundle` (macOS) / `packages/pkglist.txt` + `packages/aur.txt` via `paru` (CachyOS) | ✓ | ✓ |
| [utils](https://github.com/jasondchambers/utils) | `~/repos/utils` | ✓ | ✓ |
| ghostty | `~/.config/ghostty/` | ✓ | ✓ |
| zsh | `~/.zshrc` | ✓ | ✓ |
| starship | `~/.config/starship.toml` | ✓ | ✓ |
| nvim | `~/.config/nvim/` | ✓ | ✓ |
| git | `~/.config/git/config` | ✓ | ✓ |
| lazygit | `~/.config/lazygit/` (macOS: `~/Library/Application Support/lazygit/config.yml`) | ✓ | ✓ |
| hypr | `~/.config/hypr/` | — | ✓ |
| hammerspoon | `~/.hammerspoon/` | ✓ | — |
| karabiner | `~/.config/karabiner/` | ✓ | — |
| uv | installs the `uv` binary | ✓ | ✓ |
| tv | [television](https://github.com/alexpasmantier/television) binary | ✓ | ✓ |
| fzf_git | clones [fzf-git.sh](https://github.com/junegunn/fzf-git.sh) to `~/repos/fzf-git.sh` | ✓ | ✓ |
| eza | `~/.config/eza/` (macOS: `~/Library/Application Support/eza/`) | ✓ | ✓ |
| television | `~/.config/television/cable/` (custom channels) | ✓ | ✓ |
| rofi | `~/.config/rofi/` | — | ✓ |
| applications | `~/.local/share/applications/` (Lock Screen, Logout, Restart, Shutdown launcher entries) | — | ✓ |
| sddm | [Astronaut](https://github.com/Keyitdev/sddm-astronaut-theme) login theme via `/etc/sddm.conf.d/theme.conf` (copied with `sudo`) | — | ✓ |
| language_servers | `bash-language-server` (pacman, CachyOS only), `basedpyright`, `typescript-language-server` | ✓ | ✓ |
| clang | `~/.clang-format` + clangd's global config | ✓ | ✓ |

`hyprmod` is also a valid component (clones [BlueManCZ/hyprmod](https://github.com/BlueManCZ/hyprmod) to `~/repos/hyprmod`) but is not part of the default set installed when `install.sh` is run with no arguments — install it explicitly with `./install.sh hyprmod`.

## Selective install

Install only specific components:

```sh
./install.sh zsh nvim 
```

## First-time macOS setup

After running `install.sh`, run the system configurator for SSH keys and macOS defaults:

```sh
./configure.sh
```

## Structure

```
dot-files/
├── install.sh          # Symlinks all configs; detects OS automatically
├── configure.sh        # One-time system setup (SSH key, macOS defaults)
├── Brewfile            # Homebrew packages (macOS)
├── packages/           # Package lists (CachyOS)
│   ├── pkglist.txt     #   pacman native packages
│   └── aur.txt         #   AUR packages
├── applications/       # ~/.local/share/applications/ (launcher entries)
├── ghostty/            # ~/.config/ghostty/
├── git/                # ~/.config/git/
├── hammerspoon/        # ~/.hammerspoon/
├── hypr/               # ~/.config/hypr/
├── karabiner/          # ~/.config/karabiner/
├── lazygit/            # ~/.config/lazygit/
├── nvim/               # ~/.config/nvim/
├── starship/           # ~/.config/starship.toml
├── rofi/               # ~/.config/rofi/
├── sddm/               # /etc/sddm.conf.d/ (copied, not symlinked)
├── television/         # ~/.config/television/cable/ (custom channels)
└── zsh/                # ~/.zshrc
```

## Zsh

Entry point is `zsh/zshrc.macOS` (macOS) or `zsh/zshrc.cachyos` (CachyOS), both sourcing a shared `zsh/aliases.sh`. Config is organized as named `configure_*` functions called at the bottom of the file — each concern is self-contained and easy to find.

### Shell Features

| Feature | Tool | Notes |
|---------|------|-------|
| Prompt | [Starship](https://starship.rs/) | Cross-platform, fast, git-aware |
| Syntax highlighting | zsh-syntax-highlighting | Commands colorized as you type |
| Autosuggestions | zsh-autosuggestions | Fish-style suggestions from history |
| Fuzzy finder | [fzf](https://github.com/junegunn/fzf) | `Ctrl-R` history, `Ctrl-T` files, `Alt-C` cd; macOS also loads fzf-git.sh |
| Directory jumping | [zoxide](https://github.com/ajeetdsouza/zoxide) | `z <partial-name>` jumps to frecent dirs |
| Line editing | vi mode | `bindkey -v` — normal/insert mode in the shell |
| History | Shared, 10k lines | Persisted to `~/.zsh_history`, shared across sessions |
| `bat` theme | Catppuccin Mocha | Consistent with the rest of the color palette |
| gcloud SDK | Google Cloud SDK | macOS only — PATH and shell completion auto-loaded if installed |
| nvm | Node Version Manager | CachyOS only |

### Directory Change Hooks (`chpwd`)

Hooks fire automatically whenever you `cd` into a directory and once on shell startup:

| Hook | Platforms | Behavior |
|------|-----------|---------|
| `python_hook` | both | Auto-activates `.venv/` or `venv/` if present; deactivates when leaving |

### Aliases

| Alias | Expands to | Notes |
|-------|-----------|-------|
| `ls` | `eza` | Modern `ls` with icons and git status |
| `vi` / `vim` | `nvim` | Muscle memory redirected |
| `s` | `tv ssh` | SSH via [television](https://github.com/alexpasmantier/television) fuzzy picker |
| `sf` | `tv sftp` | SFTP via television fuzzy picker |
| `tree` | `treex` | CachyOS only |
| `open` | `xdg-open` | CachyOS only — macOS-style `open` |
| `typora` | `open -a typora` | macOS only |

### macOS-only: 1Password Environment Loader

`op-env [name]` loads a 1Password-backed service account token and environment ID into the shell. If no name is given, fzf prompts for selection.

## Notes

- All installs are idempotent — safe to re-run after changes
- Existing configs are backed up with a `.bak` suffix before being replaced

## Usage

### Copy paste

The copy/paste keys are identical between CachyOS and macOS. No more Ctrl+Shift+C to copy text in
the terminal. This. Is. Huge.

### Launching Applications

Keyboard shortcuts are used to launch commonly used applications. These are
consistent across CachyOS and macOS. Hammerspoon provides this capability on
macOS. The key mappings mirror the Hyprland bindings in `hypr/bindings.lua`.

It can take a while to get to know the keyboard shortcuts, so an application launcher
is used - [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)'s Spotlight on Hyprland and Alfred on macOS. The keybinding is identical on both

SUPER + SPACE. 

On CachyOS, DankMaterialShell (a [Quickshell](https://quickshell.org/)-based desktop shell) also provides the
bar, notifications, clipboard history, lock screen and idle handling, replacing Waybar, Rofi, hyprlock and
hypridle. Its idle/lock timeouts are set in its own settings GUI (Power & Sleep → Idle Settings), not in this repo.

### Window Management

Hyprland is used on CachyOS. On workspace 1, it uses floating windows similar to a macOS. Windows
can be cycled using Alt-Tab and moved using SUPER+drag. On the remaining workspaces, tiling is used
by default.

Hammerspoon also mirrors the Hyprland window bindings from `hypr/tiling.lua`.

With the Razer Ornata Chroma, the SUPER (Windows) key is the modifier on both CachyOS and macOS, so the bindings are identical. On the Mac's built-in/Apple keyboard, use **Option** in place of SUPER.

(This works because Karabiner swaps left Cmd and left Option on the Razer only — a `device_if` condition matches its vendor/product ID, so nothing needs toggling when docking or undocking. The Razer's SUPER key then sends Option, which Hammerspoon binds as `alt`; its Alt key sends Cmd, so Alt + F is the normal macOS Find.)

| Razer (CachyOS & macOS) | Apple keyboard (macOS) | Action |
|-------------------------|------------------------|--------|
| ALT + Q | Cmd + Q | Close window (on macOS this is the native Cmd + Q, which quits the whole app) |
| ALT + C | Cmd + C | Copy (in Ghostty on CachyOS, sends Ctrl + Shift + C so it never interrupts a running process) |
| ALT + V | Cmd + V | Paste (in Ghostty on CachyOS, sends Ctrl + Shift + V) |
| ALT + SHIFT + 4 | Cmd + Shift + 4 | Capture an area of the screen (on CachyOS: `slurp` + `grim`, saved to `~/Pictures` and copied to the clipboard) |
| CTRL + ALT + Q | Ctrl + Cmd + Q | Lock screen (on CachyOS: the DankMaterialShell lock screen; on macOS this is the native lock shortcut) |
| SUPER + F | Option + F | Toggle fullscreen |
| SUPER + ALT + F | Option + Cmd + F | Toggle maximize (fills the screen without leaving the current Space; pressing again restores the previous size) |

## Ghostty

[Ghostty](https://ghostty.org/) is a fast, native, GPU-accelerated terminal emulator. Hammerspoon's `SUPER+Return` launches it — `Option+Return` on an Apple keyboard; see [Window Management](#window-management).

**Leader key is C-b** (implemented as Ghostty key sequences)

| Key | Binding |
|-----|---------|
| **General** | |
| C-h,j,k,l | Navigate panes (passed through to Neovim/shell when there is no pane in that direction) |
| F11 / SUPER-f | Toggle fullscreen (SUPER-f macOS only, via Hammerspoon; Option-f on an Apple keyboard) |
| **Panes** | |
| \<leader> \| | New pane (split right) |
| \<leader> - | New pane (split down) |
| \<leader> m | Toggle maximize pane |
| \<leader> z | Toggle maximize pane |
| \<leader> x | Close pane |
| **Tabs** | |
| \<leader> c | New tab |
| \<leader> n | Next tab |
| \<leader> p | Previous tab |
| \<leader> 1-9 | Jump to tab by number |
| **Other** | |
| \<leader> g | Run `open-gh` |
| \<leader> [ | Search scrollback |

## Neovim

Rewritten for Neovim 0.12 using the new native plugin manager (`vim.pack`) and native LSP config API. No Mason — LSP servers are installed manually via the OS package manager. Colorscheme is `miniautumn` (from mini.nvim).

### Plugins

| Plugin | Purpose |
|--------|---------|
| **alpha-nvim** | Custom greeter screen |
| **lualine.nvim** | Status line with mode-colored segments |
| **indent-blankline.nvim** | Indentation guides (`┊`) |
| **nvim-colorizer.lua** | Inline hex color highlighting |
| **nvim-web-devicons** | File type icons |
| **nvim-tree.lua** | File explorer |
| **telescope.nvim** | Fuzzy finder (files, buffers, grep) |
| **vim-maximizer** | Toggle-maximize current split |
| **gitsigns.nvim** | Inline git hunks, blame, stage/reset |
| **lazygit.nvim** | LazyGit TUI inside Neovim |
| **nvim-treesitter** | Syntax highlighting + indentation (bash, python, JS/TS/TSX, lua, json, yaml, markdown, vim) |
| **render-markdown.nvim** | Renders markdown visually in the buffer |
| **nvim-lspconfig** | LSP client configuration |
| **nvim-undotree** | Visual undo history browser |
| **which-key.nvim** | Keybinding hints popup |

### LSP Servers

Installed manually via the OS package manager (not Mason).

| Server | Language |
|--------|---------|
| `basedpyright` | Python |
| `bashls` | Bash / sh |
| `lua_ls` | Lua |
| `ts_ls` | JavaScript / TypeScript |
| `clangd` | C / C++ |

Completion uses Neovim's native LSP completion with `<CR>` to confirm. Format-on-save is enabled for shell, Lua, JS/TS, and C/C++ files.

### Keybindings

Leader key is `Space`

| Key | Action |
|-----|--------|
| **General** | |
| \<leader>nh | Clear search highlights |
| \<leader>\| | Split window vertically |
| \<leader>- | Split window horizontally |
| \<leader>x | Close current split |
| \<leader>m | Maximize/minimize split |
| \<leader>u | Toggle Undotree |
| C-h/j/k/l | Navigate splits |
| **File Explorer** | |
| \<leader>ee | Toggle file explorer on current file |
| \<leader>ec | Collapse file explorer |
| \<leader>er | Refresh file explorer |
| **Telescope** | |
| \<leader>ff | Find files |
| \<leader>fb | Buffers |
| \<leader>fr | Recent files |
| \<leader>fg | Live grep |
| \<leader>fc | Grep string under cursor |
| C-q (in Telescope) | Send all filtered results to quickfix list |
| **Quickfix** | |
| \<leader>n | Next item in quickfix list |
| \<leader>p | Previous item in quickfix list |
| **Git** | |
| \<leader>lg | Open LazyGit |
| ]h / [h | Next / previous git hunk |
| \<leader>gp | Preview hunk |
| \<leader>gs | Stage hunk |
| \<leader>gr | Reset hunk |
| \<leader>gb | Blame line |
| **LSP** | |
| gd / gD | Go to definition / declaration |
| gr | Show references |
| K | Hover docs |
| \<leader>rn | Rename symbol |
| \<leader>ca | Code action |
| \<leader>d | Show diagnostics float |
| ]d / [d | Next / previous diagnostic |
| \<leader>td | Toggle inline diagnostics |
| **Completion** | |
| \<CR> | Confirm completion (insert mode) |
| **C** | |
| \<leader>cr | Compile and run current C file (in a terminal split) |

