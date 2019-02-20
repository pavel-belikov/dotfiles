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
    if [[ "$OSTYPE" == "darwin"* ]]; then
        DOTFILES_OPTIONS="$DOTFILES_OPTIONS dotfiles"
    else
        echo "Usage: ./install.sh  [options]"
        echo "Options:"
        echo "  -w  Awesome options"
        echo "  -d  Dotfiles"
        echo "  -l  Local git options"
        echo "  -p  Packages"
        echo "  -v  Virtual Box guest additions"
        exit 1
    fi
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
        echo "  \x1B[93mCreate link: \x1B[92m$link\x1B[0m → \x1B[96m${target#$ROOT/}\x1B[0m"
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
    unzip p7zip-full xarchiver pcmanfm mc
    pulseaudio alsa-tools alsa-utils pavucontrol
    gdebi

    git gcc g++ clang cmake valgrind gdb lldb
    vim vim-gtk exuberant-ctags cscope
    clang-tidy clang-format doxygen
    python3 python3-pip python-dev python3-dev
    build-essential
    libclang-dev llvm-dev
    libxkbfile-dev

    scrot numlockx
    lxappearance qt4-qtconfig qt5-style-plugins
    gtk2-engines-pixbuf gtk2-engines-murrine
    gnome-themes-standard adwaita-icon-theme
    fonts-hack-ttf

    firefox thunderbird keepassx

    xorg
    "

    dependencies_awesome="
    awesome dbus
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
	rm -f "$PLUG_PATH"
        curl -fLo "$PLUG_PATH" --create-dirs "$url"
        vim +PlugInstall +qa
    fi

    install_dotfile "$PLUG_PATH" "$1/.local/share/nvim/site/autoload/plug.vim"
    install_dotfile "$1/.vimrc" "$1/.config/nvim/init.vim"
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
        echo "\x1B[93m${@}\x1B[0m"
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
    opt dotfiles    install_directory dotfiles "$HOME"
    opt dotfiles    install_vim_config "$HOME"
}

install_as_root() {
    opt deps        install_dependencies
    opt deps        install_user_groups
    opt local       install_directory local "/root" -name '.vimrc'
    opt local       install_local_environment
    opt dotfiles    install_directory dotfiles "/root" -name '.vimrc'
    opt dotfiles    add_environment "QT_STYLE_OVERRIDE" "gtk"
    opt dotfiles    install_vim_config "/root"
    opt awesome     install_autologin
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    install_directory dotfiles "$HOME" -name '.vimrc' -or -name '.bash_profile'
    install_dotfile "$ROOT/dotfiles/.iterm" "$HOME/.iterm"
    install_vim_config "$HOME"
else
    case "$DOTFILES_PROFILE" in
        "")     install_wrapper "${@}" ;;
        user)   install_as_user "${@}" ;;
        root)   install_as_root "${@}" ;;
    esac
fi

