{
  description = "My Darwin system flake";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, determinate, home-manager, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # Defer to Determinate Nix
      nix.enable = false;

      environment.shells = [ pkgs.bashInteractive ];
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ (pkgs.python311.withPackages(ps: [ps.numpy]))
          pkgs.pyenv
          pkgs.coreutils
          pkgs.entr
          pkgs.git
          pkgs.git-extras
          pkgs.gnused
          pkgs.moreutils
          pkgs.socat
          # pkgs.sem  # .sem

          pkgs.protobuf
          pkgs.protoc-gen-go
          pkgs.protoc-gen-go-grpc

          pkgs.nodejs_23
          pkgs.bun
          pkgs.yarn
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
          (pkgs.writeShellScriptBin "my-flake-update-input" ''
                cd ~/.tools/config/nix-darwin
                nix flake update determinate home-manager nixpkgs nix-darwin
            '')
          (pkgs.writeShellScriptBin "my-flake-rebuild" ''
                darwin-rebuild switch --flake ~/.tools/config/nix-darwin
            '')
        ];

      # Auto upgrade nix package and the daemon service.
      # services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      # nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.bash.enable = true;  # default shell on catalina
      programs.bash.completion.enable = true;  # hopefully bash completion for everything (including nix!)
      # We use direnv for dev shells
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true; # make direnv cache better
      programs.tmux.enable = true;
      programs.tmux.enableSensible = true;
      programs.tmux.extraConfig = ''
        set-option -g prefix `
        unbind-key C-b
        bind-key e send-prefix

        bind-key ` last-window

        # http://jasonwryan.com/blog/2010/01/07/tmux-terminal-multiplexer/
        # Toggle status line using a keybinding
        bind-key b set-option status

        # TODO: Upstream these
        set-option -g pane-base-index 1

        source-file -q $HOME/.tmux.conf
      '';

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      nix.gc.automatic = true;
      nix.gc.interval = [
        {
          Hour = 10;
          Minute = 0;
        }
      ];
      nix.optimise.automatic = true;
      nix.optimise.interval = [
        {
          Hour = 11;
          Minute = 0;
        }
      ];
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;
      services.aerospace.enable = true;
      services.aerospace.settings = {
        accordion-padding = 0;
        default-root-container-layout = "accordion";
        gaps = {
          inner.horizontal = 5;
          inner.vertical =   5;
          outer.left = 5;
          outer.bottom = 5;
          outer.top = 5;
          outer.right = 5;
        };
        mode.main.binding = {
          # See: https://nikitabobko.github.io/AeroSpace/commands#layout
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          # See: https://nikitabobko.github.io/AeroSpace/commands#focus
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#move
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";
          alt-a = "workspace A";
          alt-b = "workspace B";
          alt-c = "workspace C";
          alt-d = "workspace D";
          alt-e = "workspace E";
          alt-f = "workspace F";
          alt-g = "workspace G";
          alt-i = "workspace I";
          alt-m = "workspace M";
          alt-n = "workspace N";
          alt-o = "workspace O";
          alt-p = "workspace P";
          alt-q = "workspace Q";
          alt-r = "workspace R";
          alt-s = "workspace S";
          alt-t = "workspace T";
          alt-u = "workspace U";
          alt-v = "workspace V";
          alt-w = "workspace W";
          alt-x = "workspace X";
          alt-y = "workspace Y";
          alt-z = "workspace Z";

          # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
          alt-shift-a = "move-node-to-workspace A";
          alt-shift-b = "move-node-to-workspace B";
          alt-shift-c = "move-node-to-workspace C";
          alt-shift-d = "move-node-to-workspace D";
          alt-shift-e = "move-node-to-workspace E";
          alt-shift-f = "move-node-to-workspace F";
          alt-shift-g = "move-node-to-workspace G";
          alt-shift-i = "move-node-to-workspace I";
          alt-shift-m = "move-node-to-workspace M";
          alt-shift-n = "move-node-to-workspace N";
          alt-shift-o = "move-node-to-workspace O";
          alt-shift-p = "move-node-to-workspace P";
          alt-shift-q = "move-node-to-workspace Q";
          alt-shift-r = "move-node-to-workspace R";
          alt-shift-s = "move-node-to-workspace S";
          alt-shift-t = "move-node-to-workspace T";
          alt-shift-u = "move-node-to-workspace U";
          alt-shift-v = "move-node-to-workspace V";
          alt-shift-w = "move-node-to-workspace W";
          alt-shift-x = "move-node-to-workspace X";
          alt-shift-y = "move-node-to-workspace Y";
          alt-shift-z = "move-node-to-workspace Z";
        };
      };
      services.jankyborders.enable = true;
      services.jankyborders.active_color = "0xFFF36318";
      services.jankyborders.inactive_color = "0xFF000000";
      # services.jankyborders.inactive_color = "0xFF652903";
      services.jankyborders.width = 5.0;
      # services.karabiner-elements.enable = true;
      services.spacebar.enable = true;
      services.spacebar.package = pkgs.spacebar;

      # Corner hover actions
      # 1 here means "Disabled"
      system.defaults.dock.wvous-bl-corner = 1;
      system.defaults.dock.wvous-br-corner = 1;
      system.defaults.dock.wvous-tl-corner = 1;
      system.defaults.dock.wvous-tr-corner = 1;

      system.defaults.screencapture.disable-shadow = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#HD73VL2GVX
    darwinConfigurations."RPL-HD73VL2GVX" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."RPL-HD73VL2GVX".pkgs ++ [
      nixpkgs.sem
    ];
  };
}
