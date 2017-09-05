#!/bin/bash

dotfiles=(".vimrc" ".zshrc" ".gitconfig", ".emacs")
dir="${HOME}/Documents/dotfiles"

for dotfile in "${dotfiles[@]}";do
 ln -f "${HOME}/${dotfile}" "${dir}"
done
