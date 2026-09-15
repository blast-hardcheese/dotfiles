{
  description = "My Darwin system flake";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, flake-utils, determinate, home-manager, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # Defer to Determinate Nix
      nix.enable = false;

      system.primaryUser = "dstewart";

      environment.shells = [ pkgs.bashInteractive ];
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      # Root-facing minimum only: `sudo -Hi` (my-flake-rebuild) and launchd
      # daemons see /run/current-system/sw, never ~/.nix-profile. Everything
      # user-facing lives in ~/.tools/config/.config/home-manager/flake.nix.
      environment.systemPackages =
        [
          pkgs.coreutils
          pkgs.gnugrep
          pkgs.gnused
          pkgs.git
          pkgs.jq

          # Bootstrap for the user-level flake if ~/.nix-profile is ever broken.
          pkgs.home-manager

          (pkgs.writeShellScriptBin "my-flake-update-input" ''
                set -e
                cd ~/.tools/config/nix-darwin
                nix flake update
                # Standalone home-manager flake (user-level, `home-manager switch`).
                # home-manager master and nixpkgs must move together, otherwise HM
                # warns about a version mismatch — so update all of its inputs.
                cd ~/.tools/config/.config/home-manager
                nix flake update
            '')
          (pkgs.writeShellScriptBin "my-flake-rebuild" ''
                sudo -Hi darwin-rebuild switch --flake ~/.tools/config/nix-darwin
                home-manager switch
            '')
        ];

      # Auto upgrade nix package and the daemon service.
      # services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      nix.settings = {
        experimental-features = "nix-command flakes";

        trusted-users = ["root" "dstewart"];

        substituters = [
          "https://cache.flox.dev"
        ];
        trusted-public-keys = [
          "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
        ];
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.bash.enable = true;  # default shell on catalina
      programs.bash.completion.enable = true;  # hopefully bash completion for everything (including nix!)
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # nix.gc.automatic = true;
      # nix.gc.interval = [
      #   {
      #     Hour = 10;
      #     Minute = 0;
      #   }
      # ];
      # nix.optimise.automatic = true;
      # nix.optimise.interval = [
      #   {
      #     Hour = 11;
      #     Minute = 0;
      #   }
      # ];
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;

      security.sudo = {
        extraConfig = ''
          dstewart ALL = (ALL)  NOPASSWD: /Users/dstewart/Projects/wandercom/tooling-kubernetes/.flox/run/aarch64-darwin.tooling-kubernetes.dev/bin/telepresence
        '';
      };

      # This is needed for pkgs.sem
      nixpkgs.config.allowUnsupportedSystem = true;
      # Enable TID for sudo
      security.pam.services.sudo_local.touchIdAuth = true;
      # Reattach PAM through sudo
      security.pam.services.sudo_local.reattach = true;
      services.aerospace.enable = false;
      services.aerospace.settings = {
        accordion-padding = 0;
        default-root-container-layout = "accordion";
        default-root-container-orientation = "auto";
        gaps = {
          inner.horizontal = 0;
          inner.vertical =   5;
          outer.left = 2;
          outer.bottom = 2;
          outer.top = 2;
          outer.right = 2;
        };
        mode.main.binding = {
          # See: https://nikitabobko.github.io/AeroSpace/commands#layout
          # alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          # See: https://nikitabobko.github.io/AeroSpace/commands#focus
          # alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          # alt-l = "focus right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#move
          # alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          # alt-shift-l = "move right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
          # alt-1 = "workspace 1";
          # alt-2 = "workspace 2";
          # alt-3 = "workspace 3";
          # alt-4 = "workspace 4";
          # alt-5 = "workspace 5";
          # alt-6 = "workspace 6";
          # alt-7 = "workspace 7";
          # alt-8 = "workspace 8";
          # alt-9 = "workspace 9";
          # alt-a = "workspace A";
          # alt-b = "workspace B";
          alt-c = "workspace C";
          # alt-d = "workspace D";
          # alt-e = "workspace E";
          # alt-f = "workspace F";
          # alt-g = "workspace G";
          # alt-i = "workspace I";
          # alt-m = "workspace M";
          # alt-n = "workspace N";
          # alt-o = "workspace O";
          # alt-p = "workspace P";
          # alt-q = "workspace Q";
          # alt-r = "workspace R";
          # alt-s = "workspace S";
          # alt-t = "workspace T";
          # alt-u = "workspace U";
          # alt-v = "workspace V";
          # alt-w = "workspace W";
          alt-x = "workspace X";
          # alt-y = "workspace Y";
          alt-z = "workspace Z";

          # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
          # alt-shift-1 = "move-node-to-workspace 1";
          # alt-shift-2 = "move-node-to-workspace 2";
          # alt-shift-3 = "move-node-to-workspace 3";
          # alt-shift-4 = "move-node-to-workspace 4";
          # alt-shift-5 = "move-node-to-workspace 5";
          # alt-shift-6 = "move-node-to-workspace 6";
          # alt-shift-7 = "move-node-to-workspace 7";
          # alt-shift-8 = "move-node-to-workspace 8";
          # alt-shift-9 = "move-node-to-workspace 9";
          # alt-shift-a = "move-node-to-workspace A";
          # alt-shift-b = "move-node-to-workspace B";
          alt-shift-c = "move-node-to-workspace C";
          # alt-shift-d = "move-node-to-workspace D";
          # alt-shift-e = "move-node-to-workspace E";
          # alt-shift-f = "move-node-to-workspace F";
          # alt-shift-g = "move-node-to-workspace G";
          # alt-shift-i = "move-node-to-workspace I";
          # alt-shift-m = "move-node-to-workspace M";
          # alt-shift-n = "move-node-to-workspace N";
          # alt-shift-o = "move-node-to-workspace O";
          # alt-shift-p = "move-node-to-workspace P";
          # alt-shift-q = "move-node-to-workspace Q";
          # alt-shift-r = "move-node-to-workspace R";
          # alt-shift-s = "move-node-to-workspace S";
          # alt-shift-t = "move-node-to-workspace T";
          # alt-shift-u = "move-node-to-workspace U";
          # alt-shift-v = "move-node-to-workspace V";
          # alt-shift-w = "move-node-to-workspace W";
          alt-shift-x = "move-node-to-workspace X";
          # alt-shift-y = "move-node-to-workspace Y";
          alt-shift-z = "move-node-to-workspace Z";
        };
      };
      services.jankyborders.enable = false;
      services.jankyborders.active_color = "0xFFF36318";
      services.jankyborders.inactive_color = "0xFF000000";
      # services.jankyborders.inactive_color = "0xFF652903";
      services.jankyborders.width = 5.0;
      # services.karabiner-elements.enable = true;

      # https://github.com/cmacrae/spacebar
      # impossible to google for
      services.spacebar.enable = false;
      services.spacebar.package = pkgs.spacebar;
      services.spacebar.config = {
        clock = "off";
        height = "40";
        power = "off";
        title = "off";
      };

      # Corner hover actions
      # 1 here means "Disabled"
      system.defaults.dock.wvous-bl-corner = 1;
      system.defaults.dock.wvous-br-corner = 1;
      system.defaults.dock.wvous-tl-corner = 1;
      system.defaults.dock.wvous-tr-corner = 1;

      system.defaults.screencapture.disable-shadow = true;
    };
  in
  let
    macConfig = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
      specialArgs = { inherit inputs; };
    };
  in {
    darwinConfigurations."TiBook" = macConfig;

    darwinConfigurations."m4-pro" = macConfig;
  };
}
