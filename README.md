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
| tmux | `~/.tmux.conf` | ✓ | ✓ |
| alacritty | `~/.config/alacritty/` | ✓ | ✓ |
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
./install.sh zsh nvim tmux
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
├── alacritty/          # ~/.config/alacritty/
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
├── tmux/               # ~/.tmux.conf
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

### tmux

tmux is my preferred multiplexer. It looks pretty dull out of the box and so has
been customized to my taste.

My approach to session management is completely my own, using a tool (in my
utils repo) called flip.

It enables the creation and or switching of tmux sessions whether inside or 
detached from tmux and is powered by fzf.

Be sure to checkout other tmux related utilities in In addition in [utils](https://github.com/jasondchambers/utils).

**Leader key is C-b**

| Key | Binding |
|-----|---------|
| **General** | |
| \<leader> r | Reload conf |
| \<leader> [ | Enter copy mode, navigate with vim motions, v, then y to copy|
| \<leader> g | Launch GitHub in the browser|
| C-h,j,k,l | Navigate panes (consistent with Neovim) |
| **Panes** | |
| \<leader> \| | New vertical pane |
| \<leader> - | New horizontal pane |
| \<leader> j,k,l,h | Resize pane |
| \<leader> m | Toggle maximize pane |
| \<leader> x | Kill pane |
| **Windows** | |
| \<Leader> c | Create                  |
| \<Leader> w | See all panes/sessions |
| \<leader> x | Kill window |
| **Sessions** | |
| \<Leader> d | Detach                   |
| \<Leader> s | Switch                   |

## WezTerm

> **Experimenting with WezTerm as a replacement for Alacritty + tmux.** WezTerm is a GPU-accelerated terminal emulator with built-in multiplexing (panes, tabs, workspaces), potentially eliminating the need for a separate tmux setup.

**Leader key is C-b**

| Key | Binding |
|-----|---------|
| **General** | |
| \<leader> [ | Enter copy mode, navigate with vim motions |
| F11 | Toggle fullscreen |
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

Based on [Josean's](https://www.josean.com/posts/how-to-setup-neovim-2024) setup but modified to my taste and modernized (certain things weren't working in 2026 as Josean's blog post is from 2024).

### Keybindings

Leader key is `Space`

| Key | Binding |
|-----|---------|
| **General** | |
| \<leader>nh | Clear search highlights |
| \<leader>+ | Increment number |
| \<leader>\| | Split window vertically |
| \<leader>- | Split window horizontally |
| \<leader>x | Close current split |
| \<leader>m | Maximize/minimize split |
| C-h/j/k/l | Navigate splits (consistent with tmux) |
| **File Explorer** | |
| \<leader>ee | Toggle file explorer |
| \<leader>ef | Toggle file explorer on current file |
| \<leader>ec | Collapse file explorer |
| \<leader>er | Refresh file explorer |
| **Telescope** | |
| \<leader>ff | Find files |
| \<leader>fb | Buffers |
| \<leader>fr | Recent files |
| \<leader>fg | Live grep |
| \<leader>fc | Grep string under cursor |
| **Navigation** | |
| ]f | Next function |
| [f | Previous function |
| ]d | Next diagnostic |
| [d | Previous diagnostic |
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
| gr | Go to references |
| K | Hover docs |
| \<leader>rn | Rename symbol |
| \<leader>ca | Code action |
| \<leader>d | Show diagnostics float |
| \<leader>td | Toggle inline diagnostics |
| **Debugging (DAP)** | |
| \<leader>db | Toggle breakpoint |
| \<leader>dB | Conditional breakpoint |
| \<leader>dc | Start/Continue |
| \<leader>do | Step over |
| \<leader>di | Step into |
| \<leader>dO | Step out |
| \<leader>dr | Restart |
| \<leader>dx | Terminate |
| \<leader>du | Toggle debug UI |



