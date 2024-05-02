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
          pkgs.coreutils
          pkgs.entr
          pkgs.git
          pkgs.git-extras
          pkgs.gnused
          pkgs.moreutils
          pkgs.socat

          pkgs.protobuf
          pkgs.protoc-gen-go
          pkgs.protoc-gen-go-grpc

          pkgs.nodejs_21
          pkgs.bun
          pkgs.nodePackages.pnpm

          pkgs.go

          pkgs.sbt
          pkgs.coursier
          pkgs.poetry

          pkgs.jdk

          pkgs.ghc
          pkgs.ghcid

          (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin])
          pkgs.jq
          pkgs.yq

          pkgs.neovim
          pkgs.reattach-to-user-namespace
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
    # $ darwin-rebuild build --flake .#HD73VL2GVX
    darwinConfigurations."Replit-Devon-Stewarts-MacBook-Pro-14-inch-Nov-2023" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Replit-Devon-Stewarts-MacBook-Pro-14-inch-Nov-2023".pkgs;
  };
}
