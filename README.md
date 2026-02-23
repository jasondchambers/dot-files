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

### Launching applications

Keyboard shortcuts are used to launch commonly used applications. These should
be consistent across both Omarchy and macOS. Hammerspoon is used to provide 
this capability on macOS. Checkout the Hammerspoon configuration
to learn of specific key mappings and note these should be identical to 
the Hyprland key mappings. 

### 


