#!/bin/bash

source $(dirname "$0")/lib.sh

[ ! -z "$HOME" ] && pushd $HOME 2>&1 >/dev/null || die "Unable to cd to \$HOME (\"$HOME\")"

for SOURCE_PATH in $CONFIGFILES; do
    test_path "$SOURCE_PATH" ".*/\.$" && continue
    test_path "$SOURCE_PATH" ".*/\.\.$" && continue
    test_path "$SOURCE_PATH" ".*/\.DS_Store$" && continue
    test_path "$SOURCE_PATH" ".*/\.git$" && continue  # Don't copy our git repo
    test_path "$SOURCE_PATH" ".*/\.gitignore$" && continue  # Don't copy our tracked .gitignore
    test_path "$SOURCE_PATH" ".*/\..*.sw.$" && continue

    BASE_FNAME="$HOME/$(basename "$SOURCE_PATH")"
    if [[ ! -e "$BASE_FNAME" && ! -h "$BASE_FNAME" ]]; then
        ln -v -s $SOURCE_PATH $BASE_FNAME
    elif [[ -e "$BASE_FNAME" && ! -h "$BASE_FNAME" ]]; then
        echo "$BASE_FNAME already exists and is a normal file"
    elif [[ "$($READLINK "$BASE_FNAME")" != "$($READLINK "$SOURCE_PATH")" ]]; then
        echo "$BASE_FNAME already exists, but is a symlink pointing to $($READLINK "$BASE_FNAME")"
    fi
done

popd 2>&1 >/dev/null
