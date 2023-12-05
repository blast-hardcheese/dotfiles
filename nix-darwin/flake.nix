{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ (pkgs.python311.withPackages(ps: [ps.numpy]))
          pkgs.bun
          pkgs.coreutils
          pkgs.entr
          pkgs.git
          pkgs.git-extras
          pkgs.go
          pkgs.google-cloud-sdk
          pkgs.jq
          pkgs.moreutils
          pkgs.neovim
          pkgs.nodePackages.pnpm
          pkgs.nodejs
          pkgs.reattach-to-user-namespace
          pkgs.sbt
          pkgs.tmux
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.bash.enable = true;  # default shell on catalina
      programs.bash.enableCompletion = true;  # hopefully bash completion for everything (including nix!)
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#replit-s-MacBook-Pro
    darwinConfigurations."replit-s-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."replit-s-MacBook-Pro".pkgs;
  };
}
