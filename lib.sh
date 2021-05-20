# Set up READLINK
source "$(dirname -- "$BASH_SOURCE")/.toolslib/readlink.sh"

test_path() {
    [ $(expr "$1" : "$2") -ne "0" ]
}

CONFIGDIR=$(dirname -- "$BASH_SOURCE")
CONFIGDIR_PRIVATE=$(dirname -- "$BASH_SOURCE")-private
CONFIGFILES="$CONFIGDIR/.*"
if [[ -d "$CONFIGDIR_PRIVATE" ]]; then
    CONFIGFILES="$CONFIGDIR_PRIVATE/.* $CONFIGDIR/.*"
fi

die() {
    echo "$1" >&2
    exit 1
}

contains_line() {
    local help path pattern insert
    help="$0 <path> <pattern> <insert>"
    path="$1"; shift || die "$help"
    pattern="$1"; shift || die "$help"
    insert="$1"; shift || die "$help"

    if ! grep "$pattern" "$path" >/dev/null 2>&1; then
        echo "Adding $insert to $path"
        ex -sc "1i|$insert" -cx "$path"
    fi
}

remove_line() {
    local help path pattern
    help="$0 <path> <pattern>"
    path="$1"; shift || die "$help"
    pattern="$1"; shift || die "$help"

    if grep "$pattern" "$path" > /dev/null 2>&1; then
        echo "Removing $pattern from $path"
        ex -sc "g/$pattern/d" -cx "$path"
    fi
}
