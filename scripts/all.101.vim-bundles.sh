#!/bin/bash

if ! has_install_option vim; then
    exit 0
fi

if [[ ! -e "$HOME/.vim/bundle/Vundle.vim" && -e "$HOME/.vim" ]]; then
    echo "Installing Vim Vundle..."
    git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"
fi

vim -u "$HOME/.vimrc.bundles" +PluginInstall +qa

