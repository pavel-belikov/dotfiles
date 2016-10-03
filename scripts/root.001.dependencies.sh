#!/bin/bash

set -e

dependencies=(
    sudo
    mc
    htop
    ntp
    unrar
    unzip
    p7zip-full
    gparted
    pulseaudio
    alsa-tools
    alsa-utils
    pavucontrol
    xterm

    mpd
    mpc
    gmpc
    pcmanfm
    keepassx
    xarchiver
    goldendict
    libreoffice-writer
    evince
    gimp
    firefox
    icedove
    chromium
    smplayer

    git
    gcc
    g++
    clang
    cmake
    valgrind
    gdb

    python
    python3
    python-pip
    python3-pip

    scrot
    kbdd
    numlockx
    lxappearance
    qt4-qtconfig

    vim
    vim-gtk
    exuberant-ctags

    libxkbcommon-dev
    libxkbcommon-x11-dev
    libxkbfile-dev
    libx11-dev
)

dependencies_de=(
    awesome
    dbus
)

if [[ "$INSTALL_DOTFILES_OPTIONS" != *no_de* ]]; then
    dependencies=("${dependencies[@]}" "${dependencies_de[@]}")
fi

if type apt-get &> /dev/null ; then
    dpkg --add-architecture i386
    apt-get -y -qq update
    apt-get -y -qq upgrade
    apt-get -y -qq dist-upgrade
    apt-get -y -qq install "${dependencies[@]}"
    apt-get clean
else
    echo "apt-get is not found"
fi
