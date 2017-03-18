#!/bin/sh

#TODO: remove dropbox
# - color_coded, ycm dependencies

set -e

ROOT="$(pwd)"

DOTFILES_USER="$USER"
DOTFILES_OPTIONS="Options:"
DOTFILES_HELP="no"
DOTFILES_PROFILE=""
for opt in "${@}"
do
    case "$opt" in
        -R*)
            DOTFILES_PROFILE="root"
            DOTFILES_USER="${opt#-R}"
            ;;
        -U*)
            DOTFILES_PROFILE="user"
            DOTFILES_USER="${opt#-U}"
            ;;
        --*)
            DOTFILES_OPTIONS="$DOTFILES_OPTIONS ${opt#--}"
            ;;
        -*)
            for c in `printf "%s\n" "${opt#-}" | sed 's/./& /g' | xargs`
            do
                case "$c" in
                    l) DOTFILES_OPTIONS="$DOTFILES_OPTIONS local" ;;
                    d) DOTFILES_OPTIONS="$DOTFILES_OPTIONS dotfiles" ;;
                    p) DOTFILES_OPTIONS="$DOTFILES_OPTIONS deps" ;;
                    w) DOTFILES_OPTIONS="$DOTFILES_OPTIONS awesome" ;;
                    *) DOTFILES_HELP="yes" ;;
                esac
            done
            ;;
        *) DOTFILES_HELP="yes" ;;
    esac
done

if [ "$DOTFILES_USER" = "" ]; then
    echo "Fatal Error: Couldn't get username"
    exit 1
fi

if [ "$DOTFILES_OPTIONS" = "Options:" -o "$DOTFILES_HELP" = "yes" ]; then
    echo "Usage: ./install.sh  [options]"
    echo "Options:"
    echo "  -w --awesome     Awesome options"
    echo "  -d --dotfiles    Dotfiles"
    echo "  -l --local       Local git options"
    echo "  -p --deps        Packages"
    exit 1
fi

echo "$DOTFILES_OPTIONS"

has_install_option() {
    for arg in $DOTFILES_OPTIONS
    do
        if [ "$arg" = "$1" ]; then
            return 0
        fi
    done
    return 1
}

dir() {
    rm -rf "$1"
    mkdir -p "$1"
    cd "$1"
}

install_dotfile() {
    target="$1"
    link="$2"
    rm -f "$link"
    mkdir -p "$(dirname "$link")"
    ln -s "$target" "$link"
    echo "Create link: $link → $target"
}

install_directory() {
    export INSTALL_DIRECTORY_FROM="$ROOT/$1" INSTALL_DIRECTORY_TO="$2"
    if [ -d "$INSTALL_DIRECTORY_FROM" ]; then
        cd "$INSTALL_DIRECTORY_FROM"
        find . -type f -not -name ".xinitrc" |
        while read filename
        do
            filename="${filename#./}"
            install_dotfile "$INSTALL_DIRECTORY_FROM/$filename" \
                            "$INSTALL_DIRECTORY_TO/$filename"
        done
    fi
}

install_dependencies() {
    dependencies="
    sudo htop ntp gparted curl
    mc pcmanfm xfce4-terminal
    unzip p7zip-full xarchiver
    pulseaudio alsa-tools alsa-utils pavucontrol

    fontforge

    git gcc g++ clang cmake valgrind gdb lldb
    vim vim-gtk exuberant-ctags
    qtcreator
    clang-tidy clang-format doxygen
    python3 python3-pip

    scrot kbdd numlockx
    lxappearance qt4-qtconfig qt5-style-plugins
    gtk2-engines-pixbuf gtk2-engines-murrine

    firefox thunderbird

    mpd mpc gmpc
    smplayer gimp
    goldendict keepassx
    libreoffice-writer evince
    "

    dependencies_awesome="
    awesome dbus

    libxkbcommon-dev libxkbcommon-x11-dev
    libxkbfile-dev libx11-dev
    "

    if has_install_option awesome; then
        dependencies="$dependencies $dependencies_awesome"
    fi

    dpkg --add-architecture i386
    apt -y update
    apt -y upgrade
    apt -y dist-upgrade
    apt -y install $dependencies
    apt clean
}

install_themes() {
    dir build/themes

    echo "downloading dotfiles.zip"
    wget -q -O dotfiles.zip "https://www.dropbox.com/sh/fqepviweu1sdbuf/AABmCiawlVAHao34iwy3tpuFa?dl=1"
    unzip -qq -o dotfiles.zip -d dotfiles -x / || true

    cd dotfiles

    for name in fonts themes;
    do
        if [ -d .$name ]; then
            cp -rv .$name/* /usr/share/$name
        fi
    done

    if ! grep "QT_STYLE_OVERRIDE=" /etc/environment > /dev/null 2>&1; then
        echo "export QT_STYLE_OVERRIDE=gtk2" >> /etc/environment
    fi
}

install_fonts() {
    dir build/fonts

    git clone https://github.com/MihailJP/Inconsolata-LGC.git .
    make ttf
    cp *.ttf /usr/share/fonts

    fc-cache -fv > /dev/null 2>&1
}

install_xkb_switch() {
    if type xkb-switch > /dev/null 2>&1; then
        return 0
    fi

    dir build/xkb-switch

    git clone https://github.com/ierton/xkb-switch.git
    mkdir build
    cd build
    cmake ..
    make
    make install
}

install_vim_config() {
    PLUG_PATH="$1/.vim/autoload/plug.vim"
    if [ ! -f "$PLUG_PATH" ]; then
        curl -fLo "$PLUG_PATH" --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        vim +PlugInstall +qa
    fi
}

opt() {
    cd "$ROOT"
    if has_install_option "$1"; then
        shift
        ${@}
    fi
}

case "$DOTFILES_PROFILE" in
    "")
        if ! type sudo > /dev/null 2>&1; then
            su -c "apt-install sudo && adduser $USER sudo"
        fi
        sudo "$0" "-R$USER" "${@}"
        "$0" "-U$USER" "${@}"
        ;;
    user)
        opt dotfiles    install_directory dotfiles "$HOME"
        opt awesome     install_dotfile "dotfiles/.xinitrc" "$HOME/.xinitrc"
        opt awesome     touch "$HOME/.xinitrc.local"
        opt local       install_directory local "$HOME"
        opt dotfiles    install_vim_config "$HOME"
        ;;
    root)
        opt dotfiles    install_directory dotfiles "/root"
        opt local       install_directory local "/root"
        opt deps        install_dependencies
        opt dotfiles    install_themes
        opt dotfiles    install_vim_config "/root"
        opt dotfiles    install_fonts
        opt awesome     install_xkb_switch
        ;;
    *)
        echo "Fatal Error: unknown profile $DOTFILES_PROFILE"
        exit 1
        ;;
esac

