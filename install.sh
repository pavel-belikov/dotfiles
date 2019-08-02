#!/bin/sh

set -e

ROOT="$(pwd)"

DOTFILES_OPTIONS=""
DOTFILES_HELP="no"
for opt in "${@}"
do
    case "$opt" in
        -*)
            for c in `printf "%s\n" "${opt#-}" | sed 's/./& /g' | xargs`
            do
                case "$c" in
                    l) DOTFILES_OPTIONS="$DOTFILES_OPTIONS local" ;;
                    d) DOTFILES_OPTIONS="$DOTFILES_OPTIONS dotfiles" ;;
                    p) DOTFILES_OPTIONS="$DOTFILES_OPTIONS deps" ;;
                    *) DOTFILES_HELP="yes" ;;
                esac
            done
            ;;
        *) DOTFILES_HELP="yes" ;;
    esac
done

if [ "$DOTFILES_OPTIONS" = "" -o "$DOTFILES_HELP" = "yes" ]; then
    echo "Usage: ./install.sh  [options]"
    echo "Options:"
    echo "  -d  Dotfiles"
    echo "  -l  Local dotfiles"
    echo "  -p  Packages"
    exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    DOTFILES_OPTIONS="$DOTFILES_OPTIONS mac"
else
    DOTFILES_OPTIONS="$DOTFILES_OPTIONS linux"
fi

echo "Options:$DOTFILES_OPTIONS"

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

    keepassx
    "

    su -c "apt -yq update && apt -yq upgrade && apt -yq dist-upgrade && apt -yq install $dependencies && apt clean"
}

install_brew() {
    if ! has_binary brew; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install bash-completion cloc doxygen gdb python3 ruby cmake htop conan lua neovim qt boost cppcheck \
                 flake8 valgrind cscope ninja perl subversion vim clang-format ctags gcc lcov rsync swig \
                 bash dos2unix python the_silver_searcher tree

    brew cask install macvim
}

install_dependencies() {
    if has_install_option mac; then
        install_brew
    elif has_binary apt; then
        install_apt_dependencies
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

install_local_gitconfig() {
    if ! test -f "$HOME/.gitconfig.local"; then
        printf "[user]\n    email = $(git log -1 --pretty=format:'%ae')\n    name = $(git log -1 --pretty=format:'%an')\n" > "$HOME/.gitconfig.local"
    fi
}

opt() {
    cd "$ROOT"
    for i in $(echo "$1" | tr "+" "\n")
    do
        if ! has_install_option "$i"; then
            return
        fi
    done

    shift
    echo "\x1B[93m${@}\x1B[0m"
    ${@}
}

opt deps                install_dependencies
opt dotfiles            install_directory dotfiles "$HOME" -not -path './.iterm/*'
opt dotfiles+mac        install_dotfile "$ROOT/dotfiles/.iterm" "$HOME/.iterm"
opt local               install_directory local "$HOME"
opt local               install_local_gitconfig
opt dotfiles            install_vim_config "$HOME"

