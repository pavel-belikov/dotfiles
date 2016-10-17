#!/bin/bash

if ! has_install_option root_dotfiles; then
    exit 0
fi

shopt -s dotglob

cd "$(dirname "$0")/../dotfiles" || return 0

mkdir -p ../external/root
dir="$(cd ../external/root && pwd)"

for file in .vim* .ycm* .config/mc;
do
    if [ -e "$file" ]; then
        mkdir -p "$(dirname "$dir/$file")"
        rm -rf "$dir/$file"
        ln -s "$(pwd)/$file" "$dir/$file"
    fi
done

