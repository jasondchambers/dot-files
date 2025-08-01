#
# Pre-requisities
# - zsh https://www.zsh.org/ (Omarchy default is bash - but use zsh instead)
# - https://starship.rs/
# - fzf https://github.com/junegunn/fzf
# - Catppuccin theme for bat https://github.com/catppuccin/bat
# - zsh zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
# - Neovim 
# - python-pipx (needed for uv)

def configure_history() {
   # Save command history to a file
   HISTFILE=~/.zsh_history
   HISTSIZE=10000
   SAVEHIST=10000
   setopt SHARE_HISTORY
   setopt appendhistory
}
# Setups up a very nice shell prompt from https://starship.rs/
def configure_starship() { 
   eval "$(starship init zsh)"
}

# Integrates the power of fzf with the shell
# https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line
def configure_fzf() { 
   source <(fzf --zsh)
}

# Enable command line editing to use vim
def configure_command_line_editing_to_vim() {
   bindkey -v
}

# Configure the theme for the bat command https://github.com/catppuccin/bat
def configure_bat_theme() {
   export BAT_THEME="Catppuccin Mocha"
}

def configure_zsh_autosuggestions() {
   # See https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
   source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
}

def configure_aliases() {
   alias ls='eza' # Use eza instead of ls https://github.com/eza-community/eza 
   alias vim='nvim' # Too many years of typing vi and vim
   alias vi='nvim' # Too many years of typing vi and vim
}

configure_history
configure_starship
configure_fzf
configure_command_line_editing_to_vim
configure_bat_theme
configure_zsh_autosuggestions
configure_aliases
# Created by `pipx` on 2025-07-31 21:09:32
export PATH="$PATH:/home/jasonchambers/.local/bin"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
