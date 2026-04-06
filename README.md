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

Rewritten for Neovim 0.12 using the new native plugin manager (`vim.pack`) and native LSP config API. No Mason — LSP servers are installed manually via the OS package manager.
TODO - Add DAP

### Keybindings

Leader key is `Space`

| Key | Binding |
|-----|---------|
| **General** | |
| \<leader>nh | Clear search highlights |
| \<leader>\| | Split window vertically |
| \<leader>- | Split window horizontally |
| \<leader>x | Close current split |
| \<leader>m | Maximize/minimize split |
| C-h/j/k/l | Navigate splits (consistent with WezTerm) |
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
| **Git** | |
| ]h | Next git hunk |
| [h | Previous git hunk |
| \<leader>gp | Preview hunk |
| \<leader>gs | Stage hunk |
| \<leader>gr | Reset hunk |
| \<leader>gb | Blame line |
| \<leader>lg | Open LazyGit |
| **LSP** | |
| gd | Go to definition |
| gD | Go to declaration |
| gr | Show references |
| K | Hover docs |
| \<leader>rn | Rename symbol |
| \<leader>ca | Code action |
| \<leader>d | Show diagnostics float |
| ]d | Next diagnostic |
| [d | Previous diagnostic |
| \<leader>td | Toggle inline diagnostics |
| **Completion** | |
| \<CR> | Confirm completion (insert mode) |
| **Undo** | |
| \<leader>u | Toggle Undotree |
| C-u | Undo|
| C-r | Redo|



