# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    echo "Mac detected: loading .zshrc.mac"
    source ~/.zshrc.mac
else
    echo "Linux detected: loading .zshrc.linux"
    source ~/.zshrc.linux
fi
