# Set up READLINK
source "$(dirname -- "$BASH_SOURCE")/.toolslib/readlink.sh"

test_path() {
    [ $(expr "$1" : "$2") -ne "0" ]
}

CONFIGDIR="$(dirname -- "$BASH_SOURCE")"
CONFIGDIR_PRIVATE="$(dirname -- "$BASH_SOURCE")-private"
CONFIGROOTS=( "$CONFIGDIR" )
if [[ -d "$CONFIGDIR_PRIVATE" ]]; then
  CONFIGROOTS=( "${CONFIGROOTS[@]}" "$CONFIGDIR_PRIVATE" )
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

_find_completions() {
    prefix="$1"; shift || die 'Missing prefix'
    name="$1"; shift || die 'Missing name'
    target="$1"; shift || die 'Missing target'
    dir="$1"; shift || die 'Missing dir'

    [ -d "$dir" ] || return
    if [ -n "$prefix" ]; then
        for path in "$dir/$name"*; do
            [ -f "$path" ] || return
            _target="$target/$(basename "$path")"
            [ -f "$_target" ] && return
            ln -s "$path" "$_target"
        done
    elif [ -f "$dir/$name" ]; then
        # A previous iteration could have installed it
        [ -f "$target/$name" ] && return

        ln -s "$dir/$name" "$target/$name"
    fi
}
find_completions() {
    while [ "${#@}" -gt 0 ]; do
        case "$1" in
            -p)
                prefix=1
                ;;
            *)
                name="$1"
                ;;
        esac
        shift
    done
    [ -z "$name" ] && die "Missing program name"

    mkdir -p "$HOME/.bash_completions"
    target="$HOME/.bash_completions"

    [ -f "$target/$name" ] && return

    for root in /nix/var/nix/profiles/system/sw $NIX_PROFILES; do
        [ -d "$root" ] || continue
        # Some common places for bash-completions to end up under nix
        for suffix in etc/bash_completion.d share/bash-completion/completions; do
            dir="$root/$suffix/"
            _find_completions "$name" "$prefix" "$target" "$dir"
        done
    done
    for dir in /usr/local/etc/bash_completion.d/; do
        _find_completions "$name" "$prefix" "$target" "$dir"
    done
}
