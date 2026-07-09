{
  description = "My Darwin system flake";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs2511.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    gemini-cli.url = "github:google-gemini/gemini-cli/v0.45.2";
    gemini-cli.flake = false;
  };

  outputs = inputs@{ self, flake-utils, determinate, gemini-cli, home-manager, nix-darwin, nixpkgs, nixpkgs2511 }:
  let
    pkgs2511 = nixpkgs2511.legacyPackages.aarch64-darwin;
    configuration = { pkgs, ... }:
    let
      dirstat-rs = pkgs.rustPlatform.buildRustPackage {
        pname = "dirstat-rs";
        version = "0.3.7";
        src = pkgs.fetchFromGitHub {
          owner = "scullionw";
          repo = "dirstat-rs";
          rev = "aafe0687ee2b778941451847c8a2a65789ebe85d"; # v0.3.7
          hash = "sha256-gDIUYhc+GWbQsn5DihnBJdOJ45zdwm24J2ZD2jEwGyE=";
        };
        cargoHash = "sha256-SdxTiIrsK3U4mcrcilOhMkkp12yEUkWlXmlT+C75dZw=";
      };
      codex = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "codex";
        version = "0.142.1";
        src = pkgs.fetchurl {
          url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-aarch64-apple-darwin.tar.gz";
          hash = "sha256-dGMmpwsYWDfCZg5QHDukVDv25SUP1PGlZ/vDhUtRi+0=";
        };
        sourceRoot = ".";
        installPhase = ''
          runHook preInstall
          install -Dm755 codex-aarch64-apple-darwin $out/bin/codex
          runHook postInstall
        '';
      };
      gemini-cli-package = pkgs.buildNpmPackage {
        pname = "gemini-cli";
        version = "0.45.2";
        src = gemini-cli;
        npmDepsHash = "sha256-BIZtPXDZYGjS2oBXfQ/lXyPEPzoNTogLRSr1nSvf6tY=";
        npmDepsFetcherVersion = 2;
        npmBuildScript = "bundle";
        npmInstallFlags = [ "--ignore-scripts" ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        installPhase = ''
          runHook preInstall
          mkdir -p $out/lib/gemini-cli $out/bin
          cp -RL bundle $out/lib/gemini-cli/
          cp package.json $out/lib/gemini-cli/
          makeWrapper ${pkgs.nodejs}/bin/node $out/bin/gemini \
            --add-flags "$out/lib/gemini-cli/bundle/gemini.js"
          runHook postInstall
        '';
      };
      sentry-cli = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "sentry-cli";
        version = "3.4.3";
        src = pkgs.fetchurl {
          url = "https://github.com/getsentry/sentry-cli/releases/download/${version}/sentry-cli-Darwin-arm64";
          hash = "sha256-WDgn3PnbPySJwRRWRLP0BOXYiMkvU1BiVoNEyzCoFqQ=";
        };
        dontUnpack = true;
        installPhase = ''
          runHook preInstall
          install -Dm755 $src $out/bin/sentry-cli
          runHook postInstall
        '';
      };
    in {
      # Defer to Determinate Nix
      nix.enable = false;

      system.primaryUser = "dstewart";

      environment.shells = [ pkgs.bashInteractive ];
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ (pkgs.python311.withPackages(ps: [ps.numpy]))
          pkgs.coreutils
          pkgs.gnugrep
          pkgs.entr
          pkgs.git
          pkgs.git-lfs
          pkgs.git-extras
          # pkgs.graphite-cli
          pkgs.gnused
          pkgs.moreutils
          pkgs.socat
          pkgs.pstree
          pkgs.uv
          # pkgs.sem
          pkgs.ripgrep
          pkgs.graphviz
          pkgs.k9s
          pkgs.redis
          pkgs.graphviz
          pkgs.shellcheck

          pkgs.home-manager
          pkgs.ffmpeg
          pkgs.openscad

          pkgs.disk-inventory-x

          # pkgs.protobuf
          # pkgs.protoc-gen-go
          # pkgs.protoc-gen-go-grpc

          pkgs.nodejs
          # pkgs.bun
          pkgs.yarn
          # pkgs.nodePackages.pnpm
          pkgs.corepack
          pkgs.cargo

          dirstat-rs

          # pkgs.go

          # pkgs.sbt
          # pkgs.coursier
          # pkgs.poetry

          # pkgs.jdk

          # pkgs.ghc
          # pkgs.ghcid

          pkgs.act
          pkgs.gh
          pkgs.claude-code
          codex
          gemini-cli-package

          pkgs.postgresql
          pkgs.awscli2
          pkgs.awsebcli

          # Not always cached, no sense in building it if we don't use it
          # pkgs.terraform

          (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin])
          pkgs.jq
          pkgs.yq

          pkgs.neovim
          pkgs.helix
          pkgs.reattach-to-user-namespace

          pkgs._1password-cli

          (pkgs.writeShellScriptBin "my-flake-update-input" ''
                cd ~/.tools/config/nix-darwin
                nix flake update
            '')
          (pkgs.writeShellScriptBin "my-flake-rebuild" ''
                sudo -Hi darwin-rebuild switch --flake ~/.tools/config/nix-darwin
            '')

          pkgs.doppler
          pkgs.gnupg
          # nixpkgs' sentry-cli does not build on latest nix-darwin, so we pull
          # the prebuilt release binary directly (see sentry-cli derivation above).
          sentry-cli
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
      # We use direnv for dev shells
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true; # make direnv cache better
      programs.direnv.silent = true;
      # Pin direnv to nixpkgs 25.11; skip fish integration tests (SIGKILL'd in Nix sandbox on Darwin)
      programs.direnv.package = pkgs2511.direnv.overrideAttrs (_: { doCheck = false; });
      programs.direnv.settings = {
        whitelist = {
          prefix = [
            "~/Projects/wandercom"
            "~/Projects/mea"
          ];
        };
      };
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
      services.aerospace.enable = true;
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
