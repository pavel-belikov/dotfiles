#!/bin/bash

shopt -s dotglob

cd "$(dirname "$0")/../dotfiles" || return 0

mkdir -p ../external/root
dir="$(cd ../external/root && pwd)"

for file in .vim* .ycm* .config/mc;
do
    if [ -e "$file" ]; then
        mkdir -p "$(dirname "$dir/$file")"
        ln -s "$(pwd)/$file" "$dir/$file"
    fi
done

