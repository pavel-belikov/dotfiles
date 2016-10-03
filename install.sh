#!/bin/bash

set -e
shopt -s dotglob

if [ -z "$1" ]; then
    su -c "\"$0\" root"
    "$0" user
    exit 0
fi

target="$1"
root="$(pwd)"

install_dotfile () {
    target="$1"
    link="$2"
    if [ -f "$link" ]; then
        rm -f "$link"
    fi
    mkdir -p "$(dirname "$link")"
    ln -s "$target" "$link"
    echo "Create link: $link → $target"
}

run_scripts () {
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

install_directory () {
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

export -f install_dotfile

if [ "$target" == "user" ]; then
    run_scripts user 0 99 scripts
    run_scripts user 0 99 external/scripts
    install_directory dotfiles "$HOME"
    install_directory external/dotfiles "$HOME"
    run_scripts user 100 199 scripts
    run_scripts user 100 199 external/scripts
elif [ "$target" == "root" ]; then
    run_scripts root 0 99 scripts
    run_scripts root 0 99 external/scripts
    install_directory root ""
    install_directory external/root ""
    run_scripts root 100 199 scripts
    run_scripts root 100 199 external/scripts
else
    echo "Unknown target: $target"
    exit 1
fi
