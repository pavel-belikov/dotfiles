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
    xfce4-terminal

    pcmanfm
    keepassx
    xarchiver
    goldendict
    libreoffice-writer
    evince

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

dependencies_awesome=(
    awesome
    dbus
)

dependencies_web=(
    firefox
    icedove
    chromium
)

dependencies_media=(
    mpd
    mpc
    gmpc
    smplayer
    gimp

)

if has_install_option awesome; then
    dependencies=("${dependencies[@]}" "${dependencies_awesome[@]}")
fi

if has_install_option web; then
    dependencies=("${dependencies[@]}" "${dependencies_web[@]}")
fi

if has_install_option media; then
    dependencies=("${dependencies[@]}" "${dependencies_media[@]}")
fi

if type apt-get &> /dev/null; then
    dpkg --add-architecture i386
    apt-get -y -qq update
    apt-get -y -qq upgrade
    apt-get -y -qq dist-upgrade
    apt-get -y -qq install "${dependencies[@]}"
    apt-get clean
else
    echo "apt-get is not found"
fi
