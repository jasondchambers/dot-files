#!/usr/bin/env bash
# dot-files installer
#
# Usage:
#   ./install.sh                 # install all components
#   ./install.sh zsh nvim        # install specific components
#
# Components: packages utils ghostty zsh starship nvim git lazygit
#             herdr hypr hammerspoon karabiner uv nvm tv fzf_git eza television
#             dms noctalia applications xdg_terminals audio_player sddm language_servers clang

set -eu

# Tools installed mid-run (uv, uv tools) land in ~/.local/bin, which a fresh
# shell may not have on PATH yet; later components need to find them
export PATH="$HOME/.local/bin:$PATH"

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
    paru -S --needed --noconfirm - <"$DOTFILES/packages/pkglist.txt"
    echo "  Installing AUR packages from packages/aur.txt..."
    paru -S --needed --noconfirm - <"$DOTFILES/packages/aur.txt"
    ;;
  *)
    echo -ne "skipping (unsupported OS)"
    ;;
  esac
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

install_hyprmod() {
  case "$OS" in
  cachyos)
    if [ ! -d "$HOME/repos/hyprmod" ]; then
      git clone https://github.com/BlueManCZ/hyprmod.git "$HOME/repos/hyprmod"
      (cd "$HOME/repos/hyprmod" && uv sync)
    else
      echo -ne "already present"
    fi
    ;;
  *)
    echo -ne "skipping install of hyprmod (not CachyOS)"
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
    symlink "$DOTFILES/hypr" "$HOME/.config/hypr"
    ;;
  *)
    echo -ne "skipping (not Linux)"
    ;;
  esac
  echo ""
}

# ── xdg_terminals (CachyOS only) ──────────────────────────────────────────────
# Default terminal for xdg-terminal-exec (file-manager "open terminal here",
# .desktop entries with Terminal=true)
configure_xdg_terminals() {
  echo -ne "Configuring xdg_terminals..."
  case "$OS" in
  cachyos)
    symlink "$DOTFILES/xdg/xdg-terminals.list" "$HOME/.config/xdg-terminals.list"
    ;;
  *)
    echo -ne "skipping (not Linux)"
    ;;
  esac
  echo ""
}

# ── audio_player (CachyOS only) ───────────────────────────────────────────────
# Amberol as the default app for audio files (otherwise they open in Firefox).
# Uses xdg-mime rather than symlinking ~/.config/mimeapps.list, which apps
# rewrite and which holds unrelated defaults.
AUDIO_MIME_TYPES=(
  audio/flac audio/x-flac audio/mpeg audio/mp3 audio/ogg audio/x-vorbis+ogg
  audio/opus audio/x-opus+ogg audio/wav audio/x-wav audio/aac audio/mp4
  audio/x-m4a audio/webm audio/x-aiff
)
configure_audio_player() {
  echo -ne "Configuring audio_player..."
  case "$OS" in
  cachyos)
    if ! pacman -Q amberol >/dev/null 2>&1; then
      echo ""
      # Listed in packages/pkglist.txt; install just this one here
      paru -S --needed --noconfirm amberol
    fi
    xdg-mime default io.bassi.Amberol.desktop "${AUDIO_MIME_TYPES[@]}"
    echo -ne " Amberol is the default for audio files"
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
    # Symlink the whole dir: Karabiner replaces karabiner.json on save, which
    # would break a file-level symlink
    symlink "$DOTFILES/karabiner" "$HOME/.config/karabiner"
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

# ── starship ──────────────────────────────────────────────────────────────────
install_starship() {
  echo -ne "Installing starship..."
  if ! command -v starship >/dev/null 2>&1; then
    # -y skips the installer's interactive confirmation prompt
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  else
    echo -ne "starship already installed"
  fi
  echo ""
}

# ── nvm (CachyOS only) ────────────────────────────────────────────────────────
# Node via nvm, in ~/.config/nvm (where zshrc.cachyos loads it from)
NVM_VERSION="v0.40.8"
NVM_DIR="$HOME/.config/nvm"

# nvm.sh isn't safe under `set -u`, so relax it while nvm runs
load_nvm() {
  set +u
  # shellcheck disable=SC1091
  . "$NVM_DIR/nvm.sh"
}

install_nvm() {
  echo -ne "Installing nvm..."
  case "$OS" in
  cachyos)
    if [ ! -s "$NVM_DIR/nvm.sh" ]; then
      mkdir -p "$NVM_DIR"
      # PROFILE=/dev/null: zshrc.cachyos already loads nvm, so don't let the
      # installer append to it
      curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" |
        NVM_DIR="$NVM_DIR" PROFILE=/dev/null bash
    else
      echo -ne "nvm already installed..."
    fi
    load_nvm
    nvm install --lts
    nvm alias default 'lts/*'
    set -u
    ;;
  *)
    echo -ne "skipping (not CachyOS)"
    ;;
  esac
  echo ""
}

# ── television ────────────────────────────────────────────────────────────────────────
install_tv() {
  echo -ne "Installing tv..."
  if ! command -v tv >/dev/null 2>&1; then
    case "$OS" in
    cachyos)
      # Listed in packages/pkglist.txt; install just this one here
      echo ""
      paru -S --needed --noconfirm television
      ;;
    *)
      curl -fsSL https://alexpasmantier.github.io/television/install.sh | bash
      ;;
    esac
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
  if ! command -v tv >/dev/null 2>&1; then
    install_tv
    hash -r
  fi
  echo -ne "Configuring television..."
  if ! command -v tv >/dev/null 2>&1; then
    echo -ne "skipping (tv install failed or not on PATH)"
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

# ── clang ─────────────────────────────────────────────────────────────────────
configure_clang() {
  echo -ne "Configuring clang..."
  symlink "$DOTFILES/clang/clang-format" "$HOME/.clang-format"
  case "$OS" in
  macos)
    symlink "$DOTFILES/clang/clangd-config.yaml" "$HOME/Library/Preferences/clangd/config.yaml"
    ;;
  *)
    symlink "$DOTFILES/clang/clangd-config.yaml" "$HOME/.config/clangd/config.yaml"
    ;;
  esac
  echo ""
}

# ── ghostty ───────────────────────────────────────────────────────────────────
configure_ghostty() {
  echo -ne "Configuring ghostty..."
  symlink "$DOTFILES/ghostty" "$HOME/.config/ghostty"
  case "$OS" in
  cachyos) variant="config.cachyos" ;;
  *) variant="config.macos" ;;
  esac
  ln -sfn "$DOTFILES/ghostty/$variant" "$DOTFILES/ghostty/config"
  echo -ne "  config -> $variant"
  echo ""
}

# ── herdr ─────────────────────────────────────────────────────────────────────
# Only keys.json is tracked: the rest of ~/.config/herdr-app is generated by the app.
# Shortcuts differ per OS (cmd-* on macOS, ctrl-shift-* on Linux), so link the OS variant.
configure_herdr() {
  case "$OS" in
  cachyos) variant="keys.cachyos.json" ;;
  *) variant="keys.macos.json" ;;
  esac
  configure_component "herdr" "$DOTFILES/herdr/$variant" "$HOME/.config/herdr-app/keys.json"
}

# ── noctalia (CachyOS only) ───────────────────────────────────────────────────
configure_noctalia() {
  echo -ne "Configuring noctalia..."
  case "$OS" in
  cachyos)
    # Symlink the whole dir, as with dms, in case Noctalia replaces config.toml on save
    symlink "$DOTFILES/noctalia" "$HOME/.config/noctalia"
    ;;
  *)
    echo -ne "skipping (not Linux)"
    ;;
  esac
  echo ""
}

# ── dms (CachyOS only) ────────────────────────────────────────────────────────
configure_dms() {
  echo -ne "Configuring dms..."
  case "$OS" in
  cachyos)
    # Symlink the whole dir: DankMaterialShell may replace settings.json on
    # save, which would break a file-level symlink
    symlink "$DOTFILES/dms" "$HOME/.config/DankMaterialShell"
    ;;
  *)
    echo -ne "skipping (not Linux)"
    ;;
  esac
  echo ""
}

# ── applications (CachyOS only) ───────────────────────────────────────────────
configure_applications() {
  echo -ne "Configuring applications..."
  case "$OS" in
  cachyos)
    local apps_dst="$HOME/.local/share/applications"
    mkdir -p "$apps_dst"
    for src in "$DOTFILES/applications"/*.desktop; do
      local file dst
      file=$(basename "$src")
      dst="$apps_dst/$file"
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
    ;;
  *)
    echo -ne "skipping (not Linux)"
    ;;
  esac
  echo ""
}

# ── sddm (CachyOS only) ───────────────────────────────────────────────────────
configure_sddm() {
  echo -ne "Configuring sddm..."
  case "$OS" in
  cachyos)
    echo ""
    if [ ! -d /usr/share/sddm/themes/sddm-astronaut-theme ]; then
      echo "  Installing sddm-astronaut-theme..."
      paru -S --needed --noconfirm sddm-astronaut-theme
    fi
    # Copied, not symlinked: the greeter runs as the sddm user, which can't read ~ (mode 700)
    echo "  Installing /etc/sddm.conf.d/theme.conf..."
    sudo install -Dm644 "$DOTFILES/sddm/theme.conf" /etc/sddm.conf.d/theme.conf
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
  if ! command -v typescript-language-server >/dev/null 2>&1 && [ -s "$NVM_DIR/nvm.sh" ]; then
    load_nvm
    set -u
  fi
  if ! command -v typescript-language-server >/dev/null 2>&1; then
    echo "  Installing typescript-language-server..."
    npm install -g typescript-language-server typescript
  else
    echo "  typescript-language-server already installed"
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
  zsh) configure_zsh ;;
  starship)
    install_starship
    configure_component "starship" "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
    ;;
  nvim)
    install_nvim
    configure_nvim
    ;;
  git) configure_component "git" "$DOTFILES/git/config" "$HOME/.config/git/config" ;;
  lazygit) configure_lazygit ;;
  hypr) configure_hypr ;;
  hyprmod) install_hyprmod ;;
  hammerspoon) configure_hammerspoon ;;
  karabiner) configure_karabiner ;;
  uv) install_uv ;;
  nvm) install_nvm ;;
  tv) install_tv ;;
  utils) install_utils ;;
  fzf_git) install_fzf_git ;;
  eza) configure_eza ;;
  television) configure_television ;;
  ghostty) configure_ghostty ;;
  herdr) configure_herdr ;;
  dms) configure_dms ;;
  noctalia) configure_noctalia ;;
  applications) configure_applications ;;
  xdg_terminals) configure_xdg_terminals ;;
  audio_player) configure_audio_player ;;
  sddm) configure_sddm ;;
  language_servers) install_language_servers ;;
  clang) configure_clang ;;
  *)
    echo "Unknown component: $1"
    exit 1
    ;;
  esac
}

main() {
  local all="packages utils ghostty herdr zsh starship nvim git lazygit hypr hammerspoon karabiner uv nvm tv fzf_git eza television dms noctalia applications xdg_terminals audio_player sddm language_servers clang"
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
