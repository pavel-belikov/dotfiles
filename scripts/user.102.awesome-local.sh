#!/bin/bash

if [ ! -e "$HOME/.config/awesome/config.lua" ]; then
    echo "return {music_wmclass = \"gmpc\"}" > "$HOME/.config/awesome/config.lua"
fi
