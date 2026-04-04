#!/usr/bin/env bash
# dot-files installer
#
# Usage:
#   ./install.sh                 # install all components
#   ./install.sh zsh nvim tmux   # install specific components
#
# Components: packages tmux alacritty wezterm zsh starship nvim git lazygit
#             hypr hammerspoon karabiner uv tv fzf_git eza television rofi
#             language_servers

set -eu

# ── Bootstrap ─────────────────────────────────────────────────────────────────
check_bash_version() {
  if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "Error: bash 4+ required (you have ${BASH_VERSION})."
    echo "  macOS: brew install bash"
    echo "  Others: install bash via your package manager"
    exit 1
  fi
}

# ── OS Detection ──────────────────────────────────────────────────────────────
detect_os() {
  if [ -f /etc/os-release ]; then
    ID=$(awk -F= '/^ID=/{gsub(/"/, "", $2); print $2}' /etc/os-release)
    case "$ID" in
    cachyos) echo "cachyos" ;;
    esac
  elif [ "$(uname)" = "Darwin" ]; then
    echo "macos"
  else
    echo "unknown"
  fi
}

init() {
  DOTFILES="$(cd "$(dirname "$0")" && pwd)"
  OS=$(detect_os)
}

# ── Terminal UI ───────────────────────────────────────────────────────────────
setup_terminal() {
  COLS=$(tput cols)
  ROWS=$(tput lines)
  SCROLL_BOTTOM=$((ROWS - 2))
  BAR_ROW=$((ROWS - 1))

  trap cleanup EXIT INT TERM
  tput civis
  tput csr 0 "$SCROLL_BOTTOM"
  tput cup "$SCROLL_BOTTOM" 0
  echo ""
}

draw_progress_bar() {
  local current=$1
  local total=$2
  local label=$3
  local percent=$((current * 100 / total))
  local bar_width=$((COLS - 28))
  bar_width=$((bar_width < 10 ? 10 : bar_width))
  local filled=$((bar_width * percent / 100))
  local empty=$((bar_width - filled))

  tput sc
  tput cup "$BAR_ROW" 0
  tput el
  printf "["
  printf '%.0s█' $(seq 1 "$filled")
  printf '%*s' "$empty" ''
  printf "] %d/%d (%d%%) — %s" "$current" "$total" "$percent" "$label"
  tput rc
}

cleanup() {
  local rows
  rows=$(tput lines)
  tput csr 0 $((rows - 1))
  tput cup $((rows - 1)) 0
  tput el
  tput cnorm
  echo ""
}

# ── Helpers ───────────────────────────────────────────────────────────────────
configure_component() {
  local component=$1 src=$2 dst=$3
  echo -ne "Configuring $component..."
  symlink "$src" "$dst"
  echo ""
}

symlink() {
  src="$1"
  dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo -ne "backing up ${dst/#$HOME/\~} -> ${dst/#$HOME/\~}.bak..."
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo -ne "${dst/#$HOME/\~} -> ${src/#$HOME/\~}"
}

# ── Packages ──────────────────────────────────────────────────────────────────
install_packages() {
  echo -ne "Installing packages..."
  case "$OS" in
  macos)
    if ! command -v brew >/dev/null 2>&1; then
      echo "  Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew bundle --file="$DOTFILES/Brewfile"
    ;;
  cachyos)
    echo ""
    # Install paru (AUR helper) if not present
    if ! command -v paru >/dev/null 2>&1; then
      echo "  Installing paru..."
      sudo pacman -S --needed base-devel git
      git clone https://aur.archlinux.org/paru.git /tmp/paru
      (cd /tmp/paru && makepkg -si --noconfirm)
    fi
    echo "  Installing native packages from packages/pkglist.txt..."
    paru -S --needed --noconfirm - < "$DOTFILES/packages/pkglist.txt"
    echo "  Installing AUR packages from packages/aur.txt..."
    paru -S --needed --noconfirm - < "$DOTFILES/packages/aur.txt"
    ;;
  *)
    echo -ne "skipping (unsupported OS)"
    ;;
  esac
  echo ""
}

# ── tmux ──────────────────────────────────────────────────────────────────────
clone_tpm() {
  echo -ne "Cloning tpm..."
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  else
    echo -ne "already present"
  fi
  echo ""
}

# ── alacritty ─────────────────────────────────────────────────────────────────
configure_alacritty() {
  echo -ne "Configuring alacritty..."
  # Symlink the whole alacritty dir so all theme files are accessible at
  # ~/.config/alacritty/ (required by the import directive in alacritty.toml)
  symlink "$DOTFILES/alacritty" "$HOME/.config/alacritty"
  # Point alacritty.toml at the right OS variant (file lives inside the repo dir)
  case "$OS" in
  cachyos) variant="alacritty.toml.cachyos" ;;
  *) variant="alacritty.toml.macos" ;;
  esac
  ln -sfn "$DOTFILES/alacritty/$variant" "$DOTFILES/alacritty/alacritty.toml"
  echo -ne "  alacritty.toml -> $variant"
  echo ""
}

# ── zsh ───────────────────────────────────────────────────────────────────────
configure_zsh() {
  echo -ne "Configuring zsh..."
  case "$OS" in
  cachyos) zshrc="zshrc.cachyos" ;;
  macos) zshrc="zshrc.macOS" ;;
  *)
    echo -ne "unsupported OS for zsh config (no matching zshrc variant)"
    return
    ;;
  esac
  symlink "$DOTFILES/zsh/$zshrc" "$HOME/.zshrc"
  echo ""
}

# ── nvim ──────────────────────────────────────────────────────────────────────
install_nvim() {
  case "$OS" in
  cachyos)
    if nvim --version 2>/dev/null | grep -q "^NVIM v0\.12"; then
      echo -ne "nvim 0.12 already installed"
      return
    fi
    echo -ne "Downloading nvim 0.12..."
    local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    local tmp
    tmp=$(mktemp -t nvim-XXXXXX.tar.gz)
    curl -fsSL "$url" -o "$tmp"
    tar -xzf "$tmp" -C "$HOME"
    rm -f "$tmp"
    echo -ne " installed to ~/nvim-linux-x86_64/bin/nvim"
    ;;
  *)
    echo -ne "skipping nvim binary install (not CachyOS)"
    ;;
  esac
}

configure_nvim() {
  echo -ne "Configuring nvim..."
  symlink "$DOTFILES/nvim" "$HOME/.config/nvim"
  echo ""
}

# ── lazygit ───────────────────────────────────────────────────────────────────
configure_lazygit() {
  echo -ne "Configuring lazygit..."
  case "$OS" in
  macos)
    symlink "$DOTFILES/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
    ;;
  *)
    symlink "$DOTFILES/lazygit" "$HOME/.config/lazygit"
    ;;
  esac
  echo ""
}

# ── hypr (Linux only) ─────────────────────────────────────────────────────────
configure_hypr() {
  echo -ne "Configuring hypr..."
  case "$OS" in
  cachyos)
    symlink "$DOTFILES/hypr/bindings.conf" "$HOME/.config/hypr/bindings.conf"
    ;;
  *)
    echo -ne "skipping (not Linux)"
    ;;
  esac
  echo ""
}

# ── hammerspoon (macOS only) ──────────────────────────────────────────────────
configure_hammerspoon() {
  echo -ne "Configuring hammerspoon..."
  case "$OS" in
  macos)
    symlink "$DOTFILES/hammerspoon" "$HOME/.hammerspoon"
    ;;
  *)
    echo -ne "skipping (not macOS)"
    ;;
  esac
  echo ""
}

# ── karabiner (macOS only) ────────────────────────────────────────────────────
configure_karabiner() {
  echo -ne "Configuring karabiner..."
  case "$OS" in
  macos)
    symlink "$DOTFILES/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
    ;;
  *)
    echo -ne "skipping (not macOS)"
    ;;
  esac
  echo ""
}

# ── uv ────────────────────────────────────────────────────────────────────────
install_uv() {
  echo -ne "Installing uv..."
  if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
  else
    echo -ne "uv already installed"
  fi
  echo ""
}

# ── television ────────────────────────────────────────────────────────────────────────
install_tv() {
  echo -ne "Installing tv..."
  if ! command -v tv >/dev/null 2>&1; then
    curl -fsSL https://alexpasmantier.github.io/television/install.sh | bash
  else
    echo -ne "tv already installed"
  fi
  echo ""
}

# ── utils ─────────────────────────────────────────────────────────────────────
install_utils() {
  echo -ne "Cloning utils..."
  if [ ! -d "$HOME/repos/utils" ]; then
    git clone git@github.com:jasondchambers/utils.git "$HOME/repos/utils"
  else
    echo -ne "already present"
  fi
  echo ""
}

# ── eza ───────────────────────────────────────────────────────────────────────
configure_eza() {
  echo -ne "Configuring eza..."
  # On macOS, dirs::config_dir() resolves to ~/Library/Application Support,
  # so eza looks for themes there rather than ~/.config/eza
  case "$OS" in
  macos)
    symlink "$DOTFILES/eza" "$HOME/Library/Application Support/eza"
    ;;
  *)
    symlink "$DOTFILES/eza" "$HOME/.config/eza"
    ;;
  esac
  echo ""
}

# ── television ────────────────────────────────────────────────────────────────
configure_television() {
  echo -ne "Configuring television..."
  if ! command -v tv >/dev/null 2>&1; then
    echo -ne "skipping (tv not installed)"
    echo ""
    return
  fi
  local cable_dst="$HOME/.config/television/cable"
  mkdir -p "$cable_dst"
  for src in "$DOTFILES/television/cable"/*.toml; do
    local file dst
    file=$(basename "$src")
    dst="$cable_dst/$file"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
      echo -ne " $file already linked"
      continue
    fi
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
      echo -ne " backing up $file..."
      mv "$dst" "$dst.bak"
    fi
    ln -sfn "$src" "$dst"
    echo -ne " $file"
  done
  echo ""
}

# ── wezterm ───────────────────────────────────────────────────────────────────
configure_wezterm() {
  echo -ne "Configuring wezterm..."
  symlink "$DOTFILES/wezterm" "$HOME/.config/wezterm"
  case "$OS" in
  cachyos) variant="wezterm.lua.cachyos" ;;
  *) variant="wezterm.lua.macos" ;;
  esac
  ln -sfn "$DOTFILES/wezterm/$variant" "$DOTFILES/wezterm/wezterm.lua"
  echo -ne "  wezterm.lua -> $variant"
  echo ""
}

# ── rofi (Linux only) ─────────────────────────────────────────────────────────
configure_rofi() {
  echo -ne "Configuring rofi..."
  case "$OS" in
  cachyos)
    symlink "$DOTFILES/rofi" "$HOME/.config/rofi"
    ;;
  *)
    echo -ne "skipping (not Linux)"
    ;;
  esac
  echo ""
}

# ── language servers ──────────────────────────────────────────────────────────
install_language_servers() {
  echo -ne "Installing language servers..."
  echo ""
  case "$OS" in
  cachyos)
    if ! command -v bash-language-server >/dev/null 2>&1; then
      echo "  Installing bash-language-server..."
      sudo pacman -S --noconfirm bash-language-server
    else
      echo "  bash-language-server already installed"
    fi
    ;;
  *)
    echo "  skipping bash-language-server (unsupported OS)"
    ;;
  esac
  if ! command -v basedpyright >/dev/null 2>&1; then
    echo "  Installing basedpyright..."
    uv tool install basedpyright
  else
    echo "  basedpyright already installed"
  fi
  echo ""
}

# ── fzf-git ───────────────────────────────────────────────────────────────────
install_fzf_git() {
  echo -ne "Cloning fzf-git..."
  if [ ! -d "$HOME/repos/fzf-git.sh" ]; then
    git clone https://github.com/junegunn/fzf-git.sh.git "$HOME/repos/fzf-git.sh"
  else
    echo -ne "already present"
  fi
  echo ""
}

# ── Main ──────────────────────────────────────────────────────────────────────
run() {
  case "$1" in
  packages) install_packages ;;
  tmux)
    configure_component "tmux" "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
    clone_tpm
    ;;
  alacritty) configure_alacritty ;;
  zsh) configure_zsh ;;
  starship) configure_component "starship" "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml" ;;
  nvim)
    install_nvim
    configure_nvim
    ;;
  git) configure_component "git" "$DOTFILES/git/config" "$HOME/.config/git/config" ;;
  lazygit) configure_lazygit ;;
  hypr) configure_hypr ;;
  hammerspoon) configure_hammerspoon ;;
  karabiner) configure_karabiner ;;
  uv) install_uv ;;
  tv) install_tv ;;
  utils) install_utils ;;
  fzf_git) install_fzf_git ;;
  eza) configure_eza ;;
  television) configure_television ;;
  wezterm) configure_wezterm ;;
  rofi) configure_rofi ;;
  language_servers) install_language_servers ;;
  *)
    echo "Unknown component: $1"
    exit 1
    ;;
  esac
}

main() {
  local all="packages utils tmux alacritty wezterm zsh starship nvim git lazygit hypr hammerspoon karabiner uv tv fzf_git eza television rofi language_servers"
  local -a components
  if [ "$#" -eq 0 ]; then
    components=($all)
  else
    components=("$@")
  fi

  local total=${#components[@]}
  local i=0
  draw_progress_bar 0 "$total" "starting..."
  for c in "${components[@]}"; do
    run "$c"
    i=$((i + 1))
    draw_progress_bar "$i" "$total" "$c"
  done
}

check_bash_version
init
setup_terminal
main "$@"
