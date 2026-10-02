{
  description = "Standalone home-manager (user-level, no sudo)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs2511.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Share the primary nixpkgs pin; pi may need a local build instead of its upstream cache.
    pi.url = "github:lukasl-dev/pi.nix";
    pi.inputs.nixpkgs.follows = "nixpkgs";
    herdr.url = "github:herdrdev/herdr";
    gemini-cli.url = "github:google-gemini/gemini-cli/v0.45.2";
    gemini-cli.flake = false;
  };

  outputs = { self, nixpkgs, nixpkgs2511, home-manager, pi, herdr, gemini-cli, ... }:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs2511 = nixpkgs2511.legacyPackages.${system};
    homeConfig = { username }: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        pi.homeModules.default
        ({ pkgs, ... }:
        let
          codexVersion = "0.160.0";
          codex = pkgs.stdenvNoCC.mkDerivation {
            pname = "codex";
            version = codexVersion;
            src = pkgs.fetchurl {
              url = "https://github.com/openai/codex/releases/download/rust-v${codexVersion}/codex-aarch64-apple-darwin.tar.gz";
              hash = "sha256-B8PHyjdqj3kRFTQvUxON2jfpfPopuBJdBlLZN4SJS10=";
            };
            sourceRoot = ".";
            installPhase = ''
              runHook preInstall
              install -Dm755 codex-aarch64-apple-darwin $out/bin/codex
              runHook postInstall
            '';
          };
          codex-code-mode-host = pkgs.stdenvNoCC.mkDerivation {
            pname = "codex-code-mode-host";
            version = codexVersion;
            src = pkgs.fetchurl {
              url = "https://github.com/openai/codex/releases/download/rust-v${codexVersion}/codex-code-mode-host-aarch64-apple-darwin.tar.gz";
              hash = "sha256-3HD7x26dyuWuPVQkgIyOfC314NtKyCfd1PvjOQFarXU=";
            };
            sourceRoot = ".";
            installPhase = ''
              runHook preInstall
              install -Dm755 codex-code-mode-host-aarch64-apple-darwin $out/bin/codex-code-mode-host
              runHook postInstall
            '';
          };
          claude-code = pkgs.claude-code.overrideAttrs (_: {
            version = "2.1.287";
            src = pkgs.fetchurl {
              url = "https://downloads.claude.ai/claude-code-releases/2.1.287/darwin-arm64/claude.zst";
              hash = "sha256-JwHawE4CrL6n11hPw14Erd328kAh0yHjun65WZTtz5Y=";
            };
          });
#         gemini-cli-package = pkgs.buildNpmPackage {
#           pname = "gemini-cli";
#           version = "0.45.2";
#           src = gemini-cli;
#           npmDepsHash = "sha256-BIZtPXDZYGjS2oBXfQ/lXyPEPzoNTogLRSr1nSvf6tY=";
#           npmDepsFetcherVersion = 2;
#           npmBuildScript = "bundle";
#           npmInstallFlags = [ "--ignore-scripts" ];
#           nativeBuildInputs = [ pkgs.makeWrapper ];
#           installPhase = ''
#             runHook preInstall
#             mkdir -p $out/lib/gemini-cli $out/bin
#             cp -RL bundle $out/lib/gemini-cli/
#             cp package.json $out/lib/gemini-cli/
#             makeWrapper ${pkgs.nodejs}/bin/node $out/bin/gemini \
#               --add-flags "$out/lib/gemini-cli/bundle/gemini.js"
#             runHook postInstall
#           '';
#         };
          # nixpkgs' sentry-cli does not build on latest nix-darwin, so we pull
          # the prebuilt release binary directly.
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
          home.username = username;
          home.homeDirectory = "/Users/${username}";
          home.stateVersion = "26.05";

          # Lets `home-manager` in ~/.nix-profile track this flake's home-manager input.
          programs.home-manager.enable = true;

          programs.pi.coding-agent.enable = true;
          # Options: https://github.com/lukasl-dev/pi.nix#configuration
          # programs.pi.coding-agent.rules = ./AGENTS.md;
          # programs.pi.coding-agent.skills = [ ./skills/foo ];

          # We use direnv for dev shells. The bash hook lives in ~/.tools_bashrc
          # (home-manager's shell integration only applies to its own programs.bash).
          programs.direnv = {
            enable = true;
            enableBashIntegration = false;
            enableZshIntegration = false;
            nix-direnv.enable = true; # make direnv cache better
            silent = true;
            # Pin direnv to nixpkgs 25.11; skip fish integration tests (SIGKILL'd in Nix sandbox on Darwin)
            package = pkgs2511.direnv.overrideAttrs (_: { doCheck = false; });
            config.whitelist.prefix = [
              "~/Projects/wandercom"
              "~/Projects/mea"
              "~/Projects/s2s-framework"
            ];
          };

          # User-level tooling. Root-facing basics (git, coreutils, gnugrep,
          # gnused, jq, home-manager bootstrap) stay in nix-darwin because
          # `sudo -Hi` and launchd daemons only see /run/current-system/sw.
          home.packages = [
            # (pkgs.python311.withPackages(ps: [ps.numpy]))
            pkgs.python313
            pkgs.entr
            pkgs.git-lfs
            pkgs.git-extras
            # pkgs.graphite-cli
            pkgs.moreutils
            pkgs.socat
            pkgs.pstree
            pkgs.uv
            # pkgs.sem
            pkgs.ripgrep
            pkgs.graphviz
            pkgs.k9s
            pkgs.redis
            pkgs.shellcheck

            herdr.packages.${system}.default
            pkgs.tmux
            pkgs.reattach-to-user-namespace

            pkgs.ffmpeg
            pkgs.openscad

            # pkgs.disk-inventory-x

            # pkgs.protobuf
            # pkgs.protoc-gen-go
            # pkgs.protoc-gen-go-grpc

            pkgs.nodejs
            # pkgs.bun
            pkgs.yarn
            # pkgs.nodePackages.pnpm
            # pkgs.corepack: nodejs already ships bin/corepack, and pkgs.corepack
            # also ships bin/yarn; home-manager's buildEnv rejects both collisions
            # (nix-darwin silently ignored them, so classic yarn always won).
            pkgs.cargo

            # pkgs.go

            # pkgs.sbt
            # pkgs.coursier
            # pkgs.poetry

            # pkgs.jdk

            # pkgs.ghc
            # pkgs.ghcid

            pkgs.act
            pkgs.gh
            claude-code
            codex
            codex-code-mode-host
            # gemini-cli-package

            pkgs.postgresql
            pkgs.awscli2
            pkgs.awsebcli

            # Not always cached, no sense in building it if we don't use it
            # pkgs.terraform

            (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin])
            pkgs.yq
            pkgs.imagemagick

            pkgs.neovim
            pkgs.helix

            pkgs._1password-cli

            pkgs.doppler
            pkgs.gnupg
            sentry-cli
          ];
        })
      ];
    };
  in {
    homeConfigurations."dstewart" = homeConfig { username = "dstewart"; };
    homeConfigurations."devon" = homeConfig { username = "devon"; };
  };
}
