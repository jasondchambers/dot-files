#!/usr/bin/env bash

echo "Running install.sh"
stow --verbose=1 --target=$HOME `ls -1 | grep -v "\."`
