#!/bin/bash

if ! has_install_option awesome; then
    exit 0
fi

if [ ! -e "$HOME/.config/awesome/config.lua" ]; then
    echo "return {music_wmclass = \"gmpc\"}" > "$HOME/.config/awesome/config.lua"
fi
