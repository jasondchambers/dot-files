# dot-files

Personal dotfiles for macOS, Omarchy (Arch), and Linux Mint.

## Philosophy

- Aesthetics (must look pretty)
- Consistency across platforms (macOS, Omarchy, Linux Mint)
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

| Component | Target | macOS | Omarchy | Linux Mint |
|---|---|:---:|:---:|:---:|
| [utils](https://github.com/jasondchambers/utils) | `~/repos/utils` | ✓ | ✓ | ✓ |
| tmux | `~/.tmux.conf` | ✓ | ✓ | ✓ |
| alacritty | `~/.config/alacritty/` | ✓ | ✓ | ✓ |
| zsh | `~/.zshrc` | ✓ | ✓ | ✓ |
| starship | `~/.config/starship.toml` | ✓ | ✓ | ✓ |
| nvim | `~/.config/nvim/` | ✓ | ✓ | ✓ |
| git | `~/.config/git/config` | ✓ | ✓ | ✓ |
| lazygit | `~/.config/lazygit/` | ✓ | ✓ | ✓ |
| hypr | `~/.config/hypr/bindings.conf` | — | ✓ | ✓ |
| hammerspoon | `~/.hammerspoon/` | ✓ | — | — |
| karabiner | `~/.config/karabiner/karabiner.json` | ✓ | — | — |
| packages | Homebrew (Brewfile) | ✓ | — | — |

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
├── alacritty/          # ~/.config/alacritty/
├── git/                # ~/.config/git/
├── hammerspoon/        # ~/.hammerspoon/
├── hypr/               # ~/.config/hypr/
├── karabiner/          # ~/.config/karabiner/
├── lazygit/            # ~/.config/lazygit/
├── nvim/               # ~/.config/nvim/
├── starship/           # ~/.config/starship.toml
├── tmux/               # ~/.tmux.conf
└── zsh/                # ~/.zshrc
```

## Notes

- All installs are idempotent — safe to re-run after changes
- Existing configs are backed up with a `.bak` suffix before being replaced

## Usage

### Launching Applications

Keyboard shortcuts are used to launch commonly used applications. These should
be consistent across both Omarchy and macOS. Hammerspoon is used to provide 
this capability on macOS. Checkout the Hammerspoon configuration
to learn of specific key mappings and note these should be identical to 
the Hyprland key mappings. 

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

## Neovim

Based on [Josean's](https://www.josean.com/posts/how-to-setup-neovim-2024) setup but modified to my taste and modernized (certain things weren't working in 2026 as Josean's blog post is from 2024).

### Keybindings

Leader key is C-b

| Key | Binding |
|-----|---------|
| **General** | |
| \<leader> r | reload conf |
| \<leader> [ | Enter copy mode, navigate with vim motions, v, then y to copy|
| \<leader> g | Launch GitHub in the browser|
| C-h,j,k,l | navigate panes (consistent with Neovim) |
| **Panes** | |
| \<leader> \| | new vertical pane |
| \<leader> - | new horizontal pane |
| \<leader> j,k,l,h | resize pane |
| \<leader> m | toggle maximize pane |
| \<leader> x | Kill pane |
| **Windows** | |
| \<Leader> c | created                  |
| \<Leader> w | see all panes/sessions |
| \<leader> x | Kill window |
| **Sessions** | |
| \<Leader> d | detach                   |
| \<Leader> s | switch                   |



