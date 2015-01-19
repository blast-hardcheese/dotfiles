# Get the aliases and functions

if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# Load nix
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# User specific environment and startup programs

if [ -f ~/.tools/configs/machines/$(hostname -s).bash_profile ]; then
  . ~/.tools/configs/machines/$(hostname -s).bash_profile
fi
