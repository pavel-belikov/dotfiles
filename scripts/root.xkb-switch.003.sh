#!/bin/bash

if type xkb-switch &> /dev/null; then
    exit 0
fi

cd "$(mktemp -d)"

git clone https://github.com/ierton/xkb-switch.git
mkdir build
cd build
cmake ..
make
make install

cd ..
rm -rf "$(pwd)"

