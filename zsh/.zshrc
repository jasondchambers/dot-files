# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    echo "Mac detected: loading .zshrc.mac"
    source ~/.zshrc.mac
else
    echo "Linux detected: loading .zshrc.linux"
    source ~/.zshrc.linux
fi

## Put stuff in this section that is generic
## Across Mac and Linux.
 
# Save command history to a file
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
