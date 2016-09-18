rh() { restore.sh "rawrbookpro" "Users/blast" "$1" "$2"; }

queryNixPkgs(){
  if [ -z "$NIXPKGS_ALL" ]; then
    NIXPKGS_ALL=~/.nix-defexpr/channels/nixpkgs
  fi
  nix-env -qa \* -P -f "$NIXPKGS_ALL" | grep -i "$1"
}
