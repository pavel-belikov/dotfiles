#!/bin/bash

if [ -z "$INSTALL_EXTERNAL" ]; then
    exit 0
fi

set -e

dir="$(dirname "$0")"
external_dir="$dir/../external"
mkdir -p "$external_dir"
cd "$external_dir"

wget -q -O dotfiles.zip https://www.dropbox.com/sh/fqepviweu1sdbuf/AABmCiawlVAHao34iwy3tpuFa?dl=1
unzip -qq -x / -o dotfiles.zip -d dotfiles || true
rm -f dotfiles.zip

cd dotfiles

for name in fonts themes;
do
    if [ -d .$name ]; then
        cp -r .$name /usr/share/$name
        rm -rf .$name
    fi
done

cd ..
