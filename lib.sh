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
