# Can we use readlink -f?
READLINK="readlink -f"
if [[ $($READLINK . 2>&1 >/dev/null) && $? != 0 ]]; then
  READLINK="readlink"
fi

test_path() {
    [ $(expr "$1" : "$2") -ne "0" ]
}

CONFIGDIR=$(dirname "$0")
CONFIGDIR_PRIVATE=$(dirname "$0")-private
CONFIGFILES="$CONFIGDIR/.*"
if [[ -d "$CONFIGDIR_PRIVATE" ]]; then
    CONFIGFILES="$CONFIGDIR/.* $CONFIGDIR_PRIVATE/.*"
fi

die() {
    echo "$1" >&2
    exit 1
}
