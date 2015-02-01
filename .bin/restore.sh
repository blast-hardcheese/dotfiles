from="$1"
fromdir="$2"
desired="$3"
other="$4"

if [ -z "$other" ]; then
  other="$desired"
fi

#################
# CONFIGURATION #
#################

TARGET_HOST=pewter
TARGET_PATH="/media/backups/$from"

set -x
scp -r "$TARGET_HOST:\"$TARGET_PATH/latest/$fromdir/$desired\"" "$other"
