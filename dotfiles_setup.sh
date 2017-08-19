#!/bin/bash

dotfiles=(".vimrc" ".zshrc" ".gitconfig")
dir="${HOME}/Documents/dotfiles"

for dotfile in "${dotfiles[@]}";do
 ln -f "${HOME}/${dotfile}" "${dir}"
done
