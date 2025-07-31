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

configure_starship
configure_fzf
configure_command_line_editing_to_vim
configure_bat_theme
configure_zsh_autosuggestions
configure_aliases
