mac_readlink() {
    readlink "$1"
    rc="$?"
    if [ "$rc" -eq 1 ]; then
        echo "$1"
    else
        return "$rc"
    fi
}

set_readlinks() {
    # Determine what options we can use with readlink.
    # Usage: set_readlinks "readlink -f" "readlink -e" "readlink"

    SOURCE=$(mktemp /tmp/readlink_test.XXXXX)
    TARGET=$(mktemp /tmp/readlink_test.XXXXX)

    rm $TARGET
    ln -s $SOURCE $TARGET

    for READLINK in "$@"; do
        $READLINK $TARGET 1>/dev/null 2>/dev/null
        if test $? -eq 0 ; then
            break
        fi
    done

    # Cleanup
    rm $SOURCE $TARGET
}

set_readlinks "readlink -e" "greadlink -e" "mac_readlink" "readlink"
