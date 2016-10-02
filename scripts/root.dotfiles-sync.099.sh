#!/bin/bash

shopt -s dotglob

cd "$(dirname "$0")/../dotfiles" || return 0
export INSTALL_DIRECTORY_FROM="$(pwd)" INSTALL_DIRECTORY_TO="$HOME"

dir="$(pwd)"

for file in .vim* .ycm* .config/mc;
do
    find "$file" -type f -exec bash -c 'install_dotfile "$INSTALL_DIRECTORY_FROM/{}" "$INSTALL_DIRECTORY_TO/{}"' \;
done


