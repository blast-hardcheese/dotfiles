#!/usr/bin/env bash

source "$(dirname -- "$0")/lib.sh"

[ ! -z "$HOME" ] && pushd $HOME 2>&1 >/dev/null || die "Unable to cd to \$HOME (\"$HOME\")"

contains_line "$HOME/.profile"      $'# MANAGED \.tools: .profile$'      'source "$HOME/.tools_profile"      # MANAGED .tools: .profile'
contains_line "$HOME/.bash_profile" $'# MANAGED \.tools: .bash_profile$' 'source "$HOME/.tools_bash_profile" # MANAGED .tools: .bash_profile'
contains_line "$HOME/.bashrc"       $'# MANAGED \.tools: .bashrc$'       'source "$HOME/.tools_bashrc"       # MANAGED .tools: .bashrc'

find_completions tmux
find_completions -p git
find_completions -p nix

do_setup() {
    target="$1"
    shift
    for SOURCE_PATH in "$@"; do
        # Skip .config, special-cased below
        [[ "$SOURCE_PATH" = */.config ]] && continue

        test_path "$SOURCE_PATH" ".*/\.$" && continue
        test_path "$SOURCE_PATH" ".*/\.\.$" && continue
        test_path "$SOURCE_PATH" ".*/\.DS_Store$" && continue
        test_path "$SOURCE_PATH" ".*/\.git$" && continue        # Don't copy our git repo
        test_path "$SOURCE_PATH" ".*/\.gitignore$" && continue  # Don't copy our tracked .gitignore
        test_path "$SOURCE_PATH" ".*/\.gitmodules$" && continue # Don't copy tracked .gitmodules
        test_path "$SOURCE_PATH" ".*/\..*.sw.$" && continue

        BASE_FNAME="${target}/$(basename "$SOURCE_PATH")"

        if [[ ! -e "$BASE_FNAME" && ! -h "$BASE_FNAME" ]]; then
            ln -v -s $SOURCE_PATH $BASE_FNAME
        elif [[ -e "$BASE_FNAME" && ! -h "$BASE_FNAME" ]]; then
            echo "$BASE_FNAME already exists and is a normal file"
        elif [[ "$($READLINK "$BASE_FNAME")" != "$($READLINK "$SOURCE_PATH")" ]]; then
            echo "$BASE_FNAME already exists, but is a symlink pointing to $($READLINK "$BASE_FNAME")"
        fi
    done
}

for root in "${CONFIGROOTS[@]}"; do
    do_setup "${HOME}" "${root}"/.*
    if [[ -d "${root}/.config" ]]; then
        do_setup "${HOME}/.config" "${root}/.config"/*
    fi
done

popd 2>&1 >/dev/null
