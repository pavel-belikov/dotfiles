#!/bin/bash

if [[ ! -e "$HOME/.vim/bundle/Vundle.vim" && -e "$HOME/.vim" ]]; then
    echo "Installing Vim Vundle..."
    git clone "https://github.com/gmarik/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"
fi

vim -u "$HOME/.vimrc.bundles" +PluginInstall +qa

