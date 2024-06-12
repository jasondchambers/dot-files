# Generic settings regardless of Mac or Linux
def generic_config() {

   # Setup command line editing to vim

   bindkey -v
   bindkey ^R history-incremental-search-backward
   bindkey ^S history-incremental-search-forward

   # Save command history to a file
   HISTFILE=~/.zsh_history
   HISTSIZE=10000
   SAVEHIST=10000
   setopt SHARE_HISTORY
   setopt appendhistory

   # Too many years of typing vi and vim
   alias vim='nvim'
   alias vi='nvim'

   # Make bat pretty and consistent with the shell colors
   export BAT_THEME="Catppuccin Mocha"
}

# Load OS specific settings
def load_os_specific_config() {
   # What OS are we running?
   if [[ $(uname) == "Darwin" ]]; then
      echo "Mac detected: loading .zshrc.mac"
      source ~/.zshrc.mac
   else
      echo "Linux detected: loading .zshrc.linux"
      source ~/.zshrc.linux
   fi
}

# Load host specific settings if they exist
def load_host_specific_config() {
   FILE=~/.zshrc.$(hostname) 
   if [[ -f $FILE ]]; then
       echo "Host specific config found: Loading $FILE"
       source $FILE
   fi
}

generic_config
load_os_specific_config
load_host_specific_config

## Everything after here is added during provisioning of a new
## workspace
