#!/bin/bash

set -e
shopt -s dotglob

if [[ -z "$1" || "$1" == -* ]]; then
    su -c "\"$0\" root $@"
    "$0" user $@
    exit 0
fi

target="$1"
root="$(pwd)"

INSTALL_DOTFILES_OPTIONS="awesome web media vim root_dotfiles"
for opt in "${@:2}"
do
    if [[ "$opt" == --enable-* ]]; then
        INSTALL_DOTFILES_OPTIONS="$INSTALL_DOTFILES_OPTIONS ${opt#--enable-}"
    elif [[ "$opt" == --disable-* ]]; then
        echo "$INSTALL_DOTFILES_OPTIONS" | sed "s/\s\+\<${opt#--disable-}\>\s\+/ /g"
    else
        echo "Unknown option: $opt"
        exit 1
    fi
done

install_dotfile() {
    target="$1"
    link="$2"
    rm -f "$link"
    mkdir -p "$(dirname "$link")"
    ln -s "$target" "$link"
    echo "Create link: $link → $target"
}

run_scripts() {
    target="$1"
    min_priority="$2"
    max_priority="$3"
    dir="$root/$4"
    if [ -d "$dir" ]; then
        while read script;
        do
            filename="$script"
            script="$dir/$script"
            file_target="$(echo "$filename" | cut -f1 -d. -)"
            file_priority="$(echo "$filename" | cut -f2 -d. - | sed -e 's/^0*\(.\)/\1/')"
            if [[ "$file_target" == "$target" || "$file_target" == "all" ]]; then
                if [[ "$file_priority" -ge "$min_priority" && "$file_priority" -le "$max_priority" ]]; then
                    echo "Run script: $script"
                    chmod u+x "$script"
                    "$script" || return 1
                fi
            fi
        done < <(ls -1 "$dir" | sort -k2 -t.)
    fi
}

install_directory() {
    export INSTALL_DIRECTORY_FROM="$root/$1" INSTALL_DIRECTORY_TO="$2"
    if [ -d "$INSTALL_DIRECTORY_FROM" ] ; then
        cd "$INSTALL_DIRECTORY_FROM"
        for file in *;
        do
            if [ "$file" == "*" ]; then
                return 0
            fi
        done
        find * -type f -exec bash -c 'install_dotfile "$INSTALL_DIRECTORY_FROM/{}" "$INSTALL_DIRECTORY_TO/{}"' \;
    fi
}

has_install_option() {
    for arg in $INSTALL_DOTFILES_OPTIONS
    do
        if [ "$arg" == "$1" ]; then
            return 0
        fi
    done
    return 1
}

export -f install_dotfile
export -f install_directory
export -f has_install_option
export INSTALL_DOTFILES_OPTIONS

run_scripts "$target" 0 99 scripts
run_scripts "$target" 0 99 external/scripts
install_directory dotfiles "$HOME"
install_directory external/dotfiles "$HOME"
run_scripts "$target" 100 199 scripts
run_scripts "$target" 100 199 external/scripts

