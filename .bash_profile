# Get the aliases and functions

if [ -d "$HOME/.nix-profile/etc/profile.d" ]; then
  for file in "$HOME/.nix-profile/etc/profile.d"/*; do
    source "$file"
  done
fi

if [ -d "$HOME/.nix-profile/etc/bash_completion.d" ]; then
  for file in "$HOME/.nix-profile/etc/bash_completion.d"/*; do
    source "$file"
  done
fi

if [ -f ~/.bashrc ]; then
        source ~/.bashrc
fi

[ -e "$HOME/.env_profile" ] && source "$HOME/.env_profile"

# User specific environment and startup programs

if [ -f ~/.tools/configs/machines/$(hostname -s).bash_profile ]; then
  . ~/.tools/configs/machines/$(hostname -s).bash_profile
fi
