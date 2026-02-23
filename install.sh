#!/usr/bin/env sh
# dot-files installer
#
# Usage:
#   ./install.sh                 # install all components
#   ./install.sh zsh nvim tmux   # install specific components
#
# Components: packages tmux alacritty zsh starship nvim git lazygit
#             hypr hammerspoon karabiner uv fzf_git

set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# ── OS Detection ──────────────────────────────────────────────────────────────
detect_os() {
  if [ -f /etc/arch-release ]; then
    echo "omarchy"
  elif [ -f /etc/os-release ]; then
    ID=$(awk -F= '/^ID=/{gsub(/"/, "", $2); print $2}' /etc/os-release)
    case "$ID" in
    linuxmint) echo "linuxmint" ;;
    *) echo "linux" ;;
    esac
  elif [ "$(uname)" = "Darwin" ]; then
    echo "macos"
  else
    echo "unknown"
  fi
}

OS=$(detect_os)
echo "OS: $OS"
echo "DOTFILES: $DOTFILES"
echo ""

# ── Helpers ───────────────────────────────────────────────────────────────────
symlink() {
  src="$1"
  dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backing up $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "  $dst -> $src"
}

# ── Packages ──────────────────────────────────────────────────────────────────
install_packages() {
  echo "==> packages"
  case "$OS" in
  macos)
    if ! command -v brew >/dev/null 2>&1; then
      echo "  Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew bundle --file="$DOTFILES/Brewfile"
    ;;
  *)
    echo "  Skipping (not macOS — handled by OS setup)"
    ;;
  esac
}

# ── tmux ──────────────────────────────────────────────────────────────────────
install_tmux() {
  echo "==> tmux"
  symlink "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "  Bootstrapping TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
}

# ── alacritty ─────────────────────────────────────────────────────────────────
install_alacritty() {
  echo "==> alacritty"
  # Symlink the whole alacritty dir so all theme files are accessible at
  # ~/.config/alacritty/ (required by the import directive in alacritty.toml)
  symlink "$DOTFILES/alacritty" "$HOME/.config/alacritty"
  # Point alacritty.toml at the right OS variant (file lives inside the repo dir)
  case "$OS" in
  omarchy) variant="alacritty.toml.omarchy" ;;
  linuxmint) variant="alacritty.toml.linuxmint" ;;
  *) variant="alacritty.toml.macos" ;;
  esac
  ln -sfn "$DOTFILES/alacritty/$variant" "$DOTFILES/alacritty/alacritty.toml"
  echo "  alacritty.toml -> $variant"
}

# ── zsh ───────────────────────────────────────────────────────────────────────
install_zsh() {
  echo "==> zsh"
  case "$OS" in
  omarchy) zshrc="zshrc.omarchy" ;;
  linuxmint) zshrc="zshrc.linuxmint" ;;
  macos) zshrc="zshrc.macOS" ;;
  *)
    echo "  Unsupported OS for zsh config (no matching zshrc variant)"
    return
    ;;
  esac
  symlink "$DOTFILES/zsh/$zshrc" "$HOME/.zshrc"
}

# ── starship ──────────────────────────────────────────────────────────────────
install_starship() {
  echo "==> starship"
  symlink "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
}

# ── nvim ──────────────────────────────────────────────────────────────────────
install_nvim() {
  echo "==> nvim"
  theme_lua="$DOTFILES/nvim/lua/jasondchambers/plugins/theme.lua"
  # Non-Omarchy: copy default if theme.lua is missing or is a dangling symlink
  if [ ! -f "$theme_lua" ] || [ -L "$theme_lua" ]; then
    cp "$DOTFILES/nvim/lua/jasondchambers/plugins/theme.lua.default" "$theme_lua"
    echo "  theme.lua <- default"
  fi
  symlink "$DOTFILES/nvim" "$HOME/.config/nvim"
}

# ── git ───────────────────────────────────────────────────────────────────────
install_git() {
  echo "==> git"
  symlink "$DOTFILES/git/config" "$HOME/.config/git/config"
}

# ── lazygit ───────────────────────────────────────────────────────────────────
install_lazygit() {
  echo "==> lazygit"
  symlink "$DOTFILES/lazygit" "$HOME/.config/lazygit"
}

# ── hypr (Linux only) ─────────────────────────────────────────────────────────
install_hypr() {
  echo "==> hypr"
  case "$OS" in
  omarchy | linuxmint | linux)
    symlink "$DOTFILES/hypr/bindings.conf" "$HOME/.config/hypr/bindings.conf"
    ;;
  *)
    echo "  Skipping (not Linux)"
    ;;
  esac
}

# ── hammerspoon (macOS only) ──────────────────────────────────────────────────
install_hammerspoon() {
  echo "==> hammerspoon"
  case "$OS" in
  macos)
    symlink "$DOTFILES/hammerspoon" "$HOME/.hammerspoon"
    ;;
  *)
    echo "  Skipping (not macOS)"
    ;;
  esac
}

# ── karabiner (macOS only) ────────────────────────────────────────────────────
install_karabiner() {
  echo "==> karabiner"
  case "$OS" in
  macos)
    symlink "$DOTFILES/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
    ;;
  *)
    echo "  Skipping (not macOS)"
    ;;
  esac
}

# ── uv ────────────────────────────────────────────────────────────────────────
install_uv() {
  echo "==> uv"
  if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
  else
    echo "  uv already installed"
  fi
}

# ── utils ─────────────────────────────────────────────────────────────────────
install_utils() {
  echo "==> utils"
  if [ ! -d "$HOME/repos/utils" ]; then
    git clone git@github.com:jasondchambers/utils.git "$HOME/repos/utils"
  else
    echo "  utils already present"
  fi
}

# ── fzf-git ───────────────────────────────────────────────────────────────────
install_fzf_git() {
  echo "==> fzf-git"
  if [ ! -d "$HOME/repos/fzf-git.sh" ]; then
    git clone https://github.com/junegunn/fzf-git.sh.git "$HOME/repos/fzf-git.sh"
  else
    echo "  fzf-git.sh already present"
  fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
ALL_COMPONENTS="packages utils tmux alacritty zsh starship nvim git lazygit hypr hammerspoon karabiner uv fzf_git"

run() {
  case "$1" in
  packages) install_packages ;;
  tmux) install_tmux ;;
  alacritty) install_alacritty ;;
  zsh) install_zsh ;;
  starship) install_starship ;;
  nvim) install_nvim ;;
  git) install_git ;;
  lazygit) install_lazygit ;;
  hypr) install_hypr ;;
  hammerspoon) install_hammerspoon ;;
  karabiner) install_karabiner ;;
  uv) install_uv ;;
  utils) install_utils ;;
  fzf_git) install_fzf_git ;;
  *)
    echo "Unknown component: $1"
    exit 1
    ;;
  esac
}

if [ "$#" -eq 0 ]; then
  for c in $ALL_COMPONENTS; do run "$c"; done
else
  for c in "$@"; do run "$c"; done
fi
