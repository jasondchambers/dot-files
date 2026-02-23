# dot-files

Personal dotfiles for macOS, Omarchy (Arch), and Linux Mint.

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
- `alacritty/alacritty.toml` and `nvim/.../theme.lua` are generated at install time and gitignored
- The Thelio desktop uses `zshrc.omarchy`
