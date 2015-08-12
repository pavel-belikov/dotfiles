#!/bin/bash

installDotfiles () {
	if [ "${1:0:3}" != "./." -a "$1" != "./install.sh" -a "$1" != "./README.md" -a "$1" != "./LICENSE" ]
	then
        if [ "${1:0:6}" == "./root" ]; then
            DST="${1:6}"
        else
            DST="$HOME/.${1:2}"
        fi
        if [ "$2" == "check" ]; then
            echo "check: $DST → $PWD/${1:2}"
        else
            mkdir -p "`dirname \"$DST\"`"
		    rm -f "$DST"
		    ln -s "$PWD/${1:2}" "$DST"
            echo "create link: $DST → $PWD/${1:2}"
        fi
	fi
}

export -f installDotfiles
if [ "$1" == "check" ]; then
    find -type f -exec bash -c 'installDotfiles "{}" check' \;
else
    find -type f -exec bash -c 'installDotfiles "{}"' \;
fi

if [ ! -e "$HOME/.vim/bundle/Vundle.vim" ]; then
    echo "Installing Vim Vundle..."
	git clone "https://github.com/gmarik/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"
    vim -u "$HOME/.vimrc.bundles" +PluginInstall +qa
fi

if [ ! -e "$HOME/.config/awesome/config.lua" ]; then
    echo "return {}" > "$HOME/.config/awesome/config.lua"
fi

echo "Ready"
