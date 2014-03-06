#!/bin/bash

source $(dirname "$0")/lib.sh

[ ! -z "$HOME" ] && pushd $HOME 2>&1 >/dev/null || die "Unable to cd to \$HOME (\"$HOME\")"

for SOURCE_PATH in $CONFIGFILES; do
    test_path "$SOURCE_PATH" ".*/\.$" && continue
    test_path "$SOURCE_PATH" ".*/\.\.$" && continue
    test_path "$SOURCE_PATH" ".*/\.DS_Store$" && continue
    test_path "$SOURCE_PATH" ".*/\.git$" && continue  # Don't bother with .git
    test_path "$SOURCE_PATH" ".*/\.gitignore$" && continue  # Don't bother with .gitignore
    test_path "$SOURCE_PATH" ".*/\..*.sw.$" && continue

    BASE_FNAME="$HOME/$(basename "$SOURCE_PATH")"

    if [[ -h $BASE_FNAME ]]; then
        TARGET_PATH=$($READLINK $BASE_FNAME)
        if [[ $? == 1 || $TARGET_PATH == $($READLINK "$SOURCE_PATH") ]]; then
            rm -v $BASE_FNAME
        fi
    fi
done

popd 2>&1 >/dev/null
