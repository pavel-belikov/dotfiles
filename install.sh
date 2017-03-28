#!/bin/sh

set -e

ROOT="$(pwd)"

DOTFILES_USER="$USER"
DOTFILES_OPTIONS=""
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
        -*)
            for c in `printf "%s\n" "${opt#-}" | sed 's/./& /g' | xargs`
            do
                case "$c" in
                    l) DOTFILES_OPTIONS="$DOTFILES_OPTIONS local" ;;
                    d) DOTFILES_OPTIONS="$DOTFILES_OPTIONS dotfiles" ;;
                    p) DOTFILES_OPTIONS="$DOTFILES_OPTIONS deps" ;;
                    w) DOTFILES_OPTIONS="$DOTFILES_OPTIONS awesome" ;;
                    v) DOTFILES_OPTIONS="$DOTFILES_OPTIONS virtualbox" ;;
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

if [ "$DOTFILES_OPTIONS" = "" -o "$DOTFILES_HELP" = "yes" ]; then
    echo "Usage: ./install.sh  [options]"
    echo "Options:"
    echo "  -w  Awesome options"
    echo "  -d  Dotfiles"
    echo "  -l  Local git options"
    echo "  -p  Packages"
    echo "  -v  Virtual Box guest additions"
    exit 1
fi

if [ "$DOTFILES_PROFILE" = "" ]; then
    echo "Options:$DOTFILES_OPTIONS"
fi

has_install_option() {
    for arg in $DOTFILES_OPTIONS
    do
        if [ "$arg" = "$1" ]; then
            return 0
        fi
    done
    return 1
}

has_binary() {
    if type "$1" > /dev/null 2>&1; then
        return 0
    fi
    return 1
}

has_font() {
    if has_binary fc-list; then
        if fc-list | grep "$1" > /dev/null 2>&1; then
            return 0
        fi
    fi
    return 1
}

has_theme() {
    if find "/usr/share/themes" -maxdepth 1 -name "$1" | grep . > /dev/null; then
        return 0
    fi
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
    if [ ! "`readlink "$link"`" = "$target" ]; then
        rm -f "$link"
        mkdir -p "$(dirname "$link")"
        ln -s "$target" "$link"
        echo "  \\e[93mCreate link: \\e[92m$link\\e[0m → \\e[96m${target#$ROOT/}\\e[0m"
    fi
}

install_directory() {
    export INSTALL_DIRECTORY_FROM="$ROOT/$1" INSTALL_DIRECTORY_TO="$2"
    shift; shift
    if [ -d "$INSTALL_DIRECTORY_FROM" ]; then
        cd "$INSTALL_DIRECTORY_FROM"
        find . -type f "${@}" |
        while read filename
        do
            filename="${filename#./}"
            install_dotfile "$INSTALL_DIRECTORY_FROM/$filename" \
                            "$INSTALL_DIRECTORY_TO/$filename"
        done
    fi
}

install_apt_dependencies() {
    dependencies="
    sudo htop ntp gparted curl wget strace
    ack silversearcher-ag
    mc pcmanfm xfce4-terminal
    unzip p7zip-full xarchiver
    pulseaudio alsa-tools alsa-utils pavucontrol
    gdebi
    fontforge

    git gcc g++ clang cmake valgrind gdb lldb
    vim vim-gtk3 exuberant-ctags cscope
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

    dependencies_local=""
    dependencies_vbox="virtualbox-guest-utils"

    if has_install_option awesome; then
        dependencies="$dependencies $dependencies_awesome"
    fi

    if has_install_option local; then
        dependencies="$dependencies $dependencies_local"
    fi

    if has_install_option virtualbox; then
        dependencies="$dependencies $dependencies_vbox"
    fi

    dpkg --add-architecture i386
    apt -yq update
    apt -yq upgrade
    apt -yq dist-upgrade
    apt -yq install $dependencies
    apt clean
}

install_dependencies() {
    if has_binary apt; then
        install_apt_dependencies
    fi
}

install_user_groups() {
    adduser "$DOTFILES_USER" sudo

    if has_install_option virtualbox; then
        usermod -aG vboxsf "$DOTFILES_USER"
    fi

    if ! grep "^$DOTFILES_USER" /etc/sudoers > /dev/null 2>&1; then
        echo "$DOTFILES_USER ALL= NOPASSWD: /sbin/poweroff, /sbin/reboot, /usr/bin/mount, /usr/bin/umount" >> /etc/sudoers
    fi
}

add_environment() {
    if ! grep "$1=" /etc/environment > /dev/null 2>&1; then
        echo "export $1=$2" >> /etc/environment
    fi
}

install_themes() {
    if has_theme "dorian-theme"; then
        return 0
    fi

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
}

install_fonts() {
    refresh=0

    if ! has_font "Inconsolata LGC"; then
        dir build/inconsolatalgc
        git clone https://github.com/MihailJP/Inconsolata-LGC.git .
        make ttf
        chmod 644 *.ttf
        cp *.ttf /usr/share/fonts
        refresh=1
    fi

    if [ $refresh = 1 ]; then
        fc-cache -fv > /dev/null 2>&1
    fi
}


install_xkb_switch() {
    if has_binary xkb-switch; then
        return 0
    fi

    dir build/xkb-switch

    git clone https://github.com/ierton/xkb-switch.git .
    mkdir build
    cd build
    cmake ..
    make
    make install
}

install_autologin() {
    if has_binary systemctl; then
        DIR="/etc/systemd/system/getty@tty1.service.d"
        FILE="$DIR/override.conf"
        if [ -d "$DIR" ]; then
            return 0
        fi
        EXEC="-/sbin/agetty --autologin $DOTFILES_USER --noclear %I \$TERM"
        mkdir -p "$DIR" -m755
        echo "[Service]\nExecStart=\nExecStart=$EXEC" > "$FILE"
        chmod 644 "$FILE"
        systemctl enable getty@tty1.service
        systemctl daemon-reload
    fi
}

install_vim_config() {
    PLUG_PATH="$1/.vim/autoload/plug.vim"
    if [ ! -f "$PLUG_PATH" ]; then
        url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        curl -fLo "$PLUG_PATH" --create-dirs "$url"
        vim +PlugInstall +qa
    fi
}

write_file_if_not_exists() {
    if [ ! -f "$1" ]; then
        echo "$2" > "$1"
    fi
}

install_local_environment() {
    add_environment "LC_ALL"    "en_US.UTF-8"
    add_environment "LANG"      "en_US.UTF-8"
    add_environment "LANGUAGE"  "en_US.UTF-8"
}

opt() {
    cd "$ROOT"
    if has_install_option "$1"; then
        shift
        echo "\\e[93m${@}\\e[0m"
        ${@}
    fi
}

install_wrapper() {
    if has_binary sudo; then
        sudo "$0" "-R$DOTFILES_USER" "${@}"
    else
        su -c "$0 -R$DOTFILES_USER ${@}"
    fi
    "$0" "-U$DOTFILES_USER" "${@}"
}

install_as_user() {
    opt local       install_directory local "$HOME"
    opt dotfiles    install_directory dotfiles "$HOME" -not -name ".xinitrc"
    opt dotfiles    install_vim_config "$HOME"
    opt awesome     install_dotfile "dotfiles/.xinitrc" "$HOME/.xinitrc"
    opt awesome     write_file_if_not_exists "$HOME/.config/awesome/config.lua" "return {}"
}

install_as_root() {
    opt deps        install_dependencies
    opt deps        install_user_groups
    opt local       install_directory local "/root" -name '.vimrc'
    opt local       install_local_environment
    opt dotfiles    install_directory dotfiles "/root" -name '.vimrc'
    opt dotfiles    install_themes
    opt dotfiles    add_environment "QT_STYLE_OVERRIDE" "gtk2"
    opt dotfiles    install_vim_config "/root"
    opt dotfiles    install_fonts
    opt awesome     install_autologin
    opt awesome     install_xkb_switch
}

case "$DOTFILES_PROFILE" in
    "")     install_wrapper "${@}" ;;
    user)   install_as_user "${@}" ;;
    root)   install_as_root "${@}" ;;
esac

