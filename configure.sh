#!/usr/bin/env sh
# One-time system configuration (run after install.sh)
# - Generates a GitHub SSH key
# - Fixes macOS natural scrolling direction

set -eu

generate_github_ssh_key() {
  echo "==> GitHub SSH key"
  if [ -f "$HOME/.ssh/id_ed25519" ]; then
    echo "  SSH key already exists at ~/.ssh/id_ed25519"
    return
  fi
  ssh-keygen -t ed25519 -C "jason.d.chambers@gmail.com"
  echo ""
  echo "  Copy the key below and add it at https://github.com/settings/keys"
  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy < "$HOME/.ssh/id_ed25519.pub"
    echo "  (already copied to clipboard)"
  fi
  cat "$HOME/.ssh/id_ed25519.pub"
}

fix_macos_scrolling() {
  if [ "$(uname)" = "Darwin" ]; then
    echo "==> macOS scrolling direction"
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
    echo "  Natural scrolling disabled"
  fi
}

generate_github_ssh_key
fix_macos_scrolling
