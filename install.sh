#!/bin/bash

installDotfiles () {
	if [ "${1:0:3}" != "./." -a "$1" != "./install.sh" -a "$1" != "./README.md" -a "$1" != "./LICENSE" ]
	then
		mkdir -p "`dirname \"$HOME/.${1:2}\"`"
		rm -f "$HOME/.${1:2}"
		ln -s "$PWD/${1:2}" "$HOME/.${1:2}"
		echo "$HOME/.${1:2} → $PWD/${1:2}"
	fi
}

export -f installDotfiles
find -type f -exec bash -c 'installDotfiles "{}"' \;

rm -f "$HOME/.Xresources"
echo "$HOME/.Xresources → $PWD/Xdefaults"
ln -s "$PWD/Xdefaults" "$HOME/.Xresources"

echo "Installing Vim Vundle..."
if [ ! -e "$HOME/.vim/bundle/Vundle.vim" ]; then
	git clone "https://github.com/gmarik/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"
fi
vim -u "$HOME/.vimrc.bundles" +PluginInstall +qa
echo "Ready"
