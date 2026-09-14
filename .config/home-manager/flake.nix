{
  description = "Standalone home-manager for dstewart (user-level, no sudo)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # https://github.com/lukasl-dev/pi.nix — its nixpkgs deliberately NOT set to follow ours:
    # keeping upstream's pin is what makes pi.cachix.org hits possible.
    pi.url = "github:lukasl-dev/pi.nix";
  };

  outputs = { self, nixpkgs, home-manager, pi, ... }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."dstewart" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        pi.homeModules.default
        {
          home.username = "dstewart";
          home.homeDirectory = "/Users/dstewart";
          home.stateVersion = "26.05";

          # Lets `home-manager` in ~/.nix-profile track this flake's home-manager input.
          programs.home-manager.enable = true;

          programs.pi.coding-agent.enable = true;
          # Options: https://github.com/lukasl-dev/pi.nix#configuration
          # programs.pi.coding-agent.rules = ./AGENTS.md;
          # programs.pi.coding-agent.skills = [ ./skills/foo ];
        }
      ];
    };
  };
}
