# dot-files

Personal dotfiles for macOS and CachyOS.

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
| [utils](https://github.com/jasondchambers/utils) | `~/repos/utils` | ✓ | ✓ |
| wezterm | `~/.config/wezterm/` | ✓ | ✓ |
| zsh | `~/.zshrc` | ✓ | ✓ |
| starship | `~/.config/starship.toml` | ✓ | ✓ |
| nvim | `~/.config/nvim/` | ✓ | ✓ |
| git | `~/.config/git/config` | ✓ | ✓ |
| lazygit | `~/.config/lazygit/` | ✓ | ✓ |
| hypr | `~/.config/hypr/bindings.conf` | — | ✓ |
| rofi | `~/.config/rofi/` | — | ✓ |
| hammerspoon | `~/.hammerspoon/` | ✓ | — |
| karabiner | `~/.config/karabiner/karabiner.json` | ✓ | — |
| packages | Brewfile (macOS) / pkglist.txt + aur.txt (CachyOS) | ✓ | ✓ |
| tv | [television](https://github.com/alexpasmantier/television) binary | ✓ | ✓ |
| television | `~/.config/television/cable/` (custom channels) | ✓ | ✓ |

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
├── wezterm/            # ~/.config/wezterm/
├── git/                # ~/.config/git/
├── hammerspoon/        # ~/.hammerspoon/
├── hypr/               # ~/.config/hypr/
├── karabiner/          # ~/.config/karabiner/
├── lazygit/            # ~/.config/lazygit/
├── nvim/               # ~/.config/nvim/
├── starship/           # ~/.config/starship.toml
├── rofi/               # ~/.config/rofi/
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

### Launching Applications

Keyboard shortcuts are used to launch commonly used applications. These are
consistent across CachyOS and macOS. Hammerspoon provides this capability on
macOS. The key mappings mirror the Hyprland bindings in `hypr/bindings.conf`.

It can take a while to get to know the keyboard shortcuts, so an application launcher
is used - Rofi on Hyprland and Alfred on macOS. The keybinding is identical on both

SUPER + SPACE. 

### tmux

tmux was my preferred multiplexer. However, it has been retired along with Alacritty
by WezTerm - which has pretty much a built-in multiplexer that meets my needs.

## WezTerm

WezTerm is a GPU-accelerated terminal emulator with built-in multiplexing (panes, tabs, workspaces), potentially eliminating the need for a separate tmux setup.

**Leader key is C-b**

| Key | Binding |
|-----|---------|
| **General** | |
| C-h,j,k,l | Navigate panes (seamless with Neovim) |
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
| **Workspaces** (sessions) | |
| \<leader> s | Show workspace switcher |
| \<leader> L | Switch to previous workspace |

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
| **smart-splits.nvim** | Seamless split navigation across WezTerm panes |
| **which-key.nvim** | Keybinding hints popup |

### LSP Servers

Installed manually via the OS package manager (not Mason).

| Server | Language |
|--------|---------|
| `basedpyright` | Python |
| `bashls` | Bash / sh |

Completion uses Neovim's native LSP completion with `<CR>` to confirm. Format-on-save is enabled for shell files.

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
| C-h/j/k/l | Navigate splits (seamless with WezTerm) |
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



