py() {
  (
    if [[ "x$1" == "x-i" ]]; then
      I=$1
      shift
    fi
    python $I -- ~/.tools/code/python/blast_common.py "$@"
  )
}

np_activate() {
  root="$(pwd)"
  if [ ! -z "$1" ]; then
    root="$1"
  fi

  if [ -d "${root}/node_modules" ]; then
    if [ -f "${root}/package.json" ] && hash jq; then
        if [ -d "$HOME/.nvm" ] && [ ! -z "$NVM_DIR" ]; then
            [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

            nodeVersion="$(jq -cMr '.engines.node' < ${root}/package.json)"
            nvm use "$nodeVersion"
        fi
    fi

    export NODE_PATH="${root}/node_modules"
    export PATH="${root}/node_modules/.bin:$PATH"
  else
    echo "Unable to find node_modules" >&2
  fi
}

# Set terminal title
# @param string $1  Tab/window title
# @param string $2  (optional) Separate window title
# The latest version of this software can be obtained here:
# See: http://fvue.nl/wiki/NameTerminal
# http://ubuntuforums.org/showthread.php?t=448614
function title() {
    [ "${TERM:0:5}" = "xterm" ]   && local ansiNrTab=0
    [ "$TERM"       = "rxvt" ]    && local ansiNrTab=61
    [ "$TERM"       = "konsole" ] && local ansiNrTab=30 ansiNrWindow=0
        # Change tab title
    [ $ansiNrTab ] && echo -n $'\e'"]$ansiNrTab;$1"$'\a'
        # If terminal support separate window title, change window title as well
    [ $ansiNrWindow -a "$2" ] && echo -n $'\e'"]$ansiNrWindow;$2"$'\a'
} # nameTerminal()


sdu() { du -shx "$@" | perl -e '%byte_order = ( G => 0, M => 1, K => 2 ); print map { $_->[0] } sort { $byte_order{$a->[1]} <=> $byte_order{$b->[1]} || $b->[2] <=> $a->[2] } map { [ $_, /([MGK])/, /(\d+)/ ] } <>'; }

upload() {
  for FILE in "$@"; do
    TARGETHOST="viridian"
    TARGETBASEPATH="/home/blast/public_html/files/"

    DATE=$(date +"%Y-%m-%d")
    TARGETPATH=$TARGETBASEPATH/$DATE

    DIRNAME=$(dirname "$FILE")
    BASENAME=$(basename "$FILE")
    ESCAPED_NAME=$(echo $BASENAME | urlquote)

    tar -C "$DIRNAME" -czf - "$BASENAME" | ssh $TARGETHOST "mkdir -p \"$TARGETPATH\" && tar -C \"$TARGETPATH\" -xzf - && find \"$TARGETPATH/$BASENAME\" \( -type f -exec chmod 644 {} + \) -o \( -type d -exec chmod 755 {} + \)";

    URL="http://blast.hardchee.se/~/files/$DATE/$ESCAPED_NAME";
    echo $URL;
    if [ -n "$XCLIP_IN" ]; then
        echo -n $URL | $XCLIP_IN;
        echo "Copied to pasteboard"
    fi
  done
}

md5tree() {
  find "$1" -type f -exec md5sum {} \; | sed -e 's/  .*$//' | sort | md5sum -
}

escape() {
  printf "%q\n" "$(cat -)"
}

reset_keyboard() {
    setxkbmap

    if [ -f ~/.xmodmaprc ]; then
        xmodmap ~/.xmodmaprc
    fi
}

git-ref() {
    COMMIT="$1"
    if [ -z "$COMMIT" ]; then
        COMMIT="HEAD"
    fi

    git rev-parse "$COMMIT" | cut -c -7
}

git-curbranch() {
    git branch | grep ^\* | cut -f 2 -d ' '
}

# Handy for code reviews. Run format-gitdiff, copy/paste into an email.
format-gitdiff() {
    COMMIT="$1"
    if [ -z "$COMMIT" ]; then
        COMMIT="origin/master"
    fi

    echo Branch: $(git-curbranch)
    echo "    git log -p $(git-ref "$COMMIT")..$(git-ref)"
}

swap_files() {
    F1="$1";
    F2="$2";

    if [[ ! -e "$F1" ]] || [[ ! -e "$F2" ]]; then
        echo "Usage: swap_files FILE1 FILE2"
        if [[ ! -e "$F1" ]]; then
            echo "  $F1 doesn't exist"
        fi
        if [[ ! -e "$F2" ]]; then
            echo "  $F2 doesn't exist"
        fi
        return 1
    fi

    if [[ -e "$F1-bak" ]] ; then
        echo "Swap file \"$F1-bak\" already exists\!"
        return 2
    fi

    mv -v "$F1" "$F1"-bak && \
    mv -v "$F2" "$F1" && \
    mv -v "$F1"-bak "$F2"
}

### Desktop machines

archive_images() {
    TODAY=$(date +"%Y-%m-%d")
    TARGET="$HOME/Desktop_Images"
    if [[ ! -e "$TARGET" ]]; then
        mkdir -p "$TARGET"
    elif [[ ! -d "$TARGET" ]]; then
        echo \"$TARGET\" is not a directory\!
        return 1
    fi
    for IPATH in "$@"; do
        IBASEPATH=$(dirname "$IPATH")
        IFILE=$(basename "$IPATH")
        ITARGET="$TODAY-$IFILE"
        if [[ "$IFILE" == "$TODAY-"* ]]; then
            echo Already OK: $IFILE
            ITARGET="$IFILE"
        fi
        mv -vi "$IPATH" "$TARGET/$ITARGET"
    done
}

date_PT() {
    TZ=America/Los_Angeles date
}

date_JT() {
    TZ=Japan date
}

date_UTC() {
    TZ=UTC date
}

sconsole() {
    if type sbt >/dev/null 2>&1; then
        SCDIR="$HOME/.sconsole"
        echo "Launching sbt console in $SCDIR..."
        mkdir -p "$SCDIR"
        pushd "$SCDIR" >/dev/null
        sbt console-quick
        popd >/dev/null
    else
        echo "sbt not found!"
    fi
}

build_index() {
    (echo "<html><body>"; ls | grep -vi 'index.html' | perl -ne '
        chomp;
        $F=$_;
        s~^(.*.(jpg|jpeg|png|gif))$~<img src="\1" />~;
        s~^(.*)$~<a href="$F">$1</a><br />\n~;
        print
    '; echo "</body></html>") > index.html
}

adjust_size() {
    size=$1
    shift

    if [ "x" = "x$size" -o -f "$size" ]; then
        echo "Usage: adjust_size size_spec file [file2 [file3...]]"
        return 1
    fi

    for P in "$@"; do
        O="${P%\.*}-$size.${P##*\.}"
        if [ -e "$O" ]; then
            echo "Info: '$O' already exists, skipping.";
            continue
        fi
        convert "$P" -resize $size -rotate 0 "$O"
    done
}

clean_play() {
    F=$(mktemp -t cleanFile.vim)
    echo '
:if &readonly
:q!
:endif
:%s/\s\+$//
:set ff=unix
:wq
    ' > "$F"
    find . \! -path '*/.git/*' -type f \! -name '*.png' \! -name '*.js' -exec vim -s "$F" {} \;
    rm "$F"
}

mcd() {
    mkdir -p "$1"
    cd "$1"
}

jinja2() {
    python -c 'import sys, jinja2; print jinja2.Template(open(sys.argv[1]).read()).render()' "$1"
}

# Exploratory vim hammer.
# Usage: vimp <find(1) path pattern>
# What is to be expected is a prompt showing which files matched the pattern,
# offering the option to open them all in tabs.
# This was written before I integrated Ctrl-P into my workflow.
vimp() {
  unset files i
  echo "Edit files:"
  for name in "$@"; do
    while IFS= read -r -u3 -d $'\0' file; do
      files[i++]="$file"
      echo "  $i: $file"
      if [[ $i -eq 50 ]]; then
        echo "Continue?"
        read
      fi
    done 3< <(find . -type f -name "$name" \! -path '*/target/*' -print0)
  done

  if [[ $i -gt 1 ]]; then
    echo "[Press enter]"
    read
  fi
  vim -p "${files[@]}"
}

#### Overrides
if [ -f ~/.tools/configs/machines/$(hostname -s).bash_functions ]; then
  . ~/.tools/configs/machines/$(hostname -s).bash_functions
fi
