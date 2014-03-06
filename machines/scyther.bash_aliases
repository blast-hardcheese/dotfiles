grepznc() {
  CHANNEL=$1
  shift
  PATTERN=$1
  shift
  OPTIONS=$@
  NETWORK=\*
  LOGPATH=~/.znc/users/$NETWORK/moddata/log/

  if [[ "xx$CHANNEL" == "xx" || "xx$PATTERN" == "xx" ]]; then
    echo 'Usage: grepznc "#channel" pattern'
  else
    find $LOGPATH -name '*'$CHANNEL'*' -exec zgrep -i $PATTERN "{}" $OPTIONS \;
  fi
}

