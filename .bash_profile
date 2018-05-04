# Get the aliases and functions

if [ -d "$HOME/.nix-profile/etc/profile.d" ]; then
  for file in "$HOME/.nix-profile/etc/profile.d"/*; do
    source "$file"
  done
fi

if [ -f ~/.bashrc ]; then
        source ~/.bashrc
fi

[ -e "$HOME/.env_profile" ] && source "$HOME/.env_profile"

# Load nix
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# User specific environment and startup programs

if [ -f ~/.tools/configs/machines/$(hostname -s).bash_profile ]; then
  . ~/.tools/configs/machines/$(hostname -s).bash_profile
fi
