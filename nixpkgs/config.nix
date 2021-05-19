{
  allowUnfree = true;
  allowUnsupportedSystem = true;
  allowBroken = true;

  packageOverrides = pkgs: rec {
    # myNeovim = pkgs.neovim.override { extraPythonPackages = with pkgs.pythonPackages; [ websocket_client sexpdata ]; };
    imagemagick = pkgs.imagemagick.override { ghostscript = pkgs.ghostscript; };

    all = let
      pkgs = import <nixpkgs> { overlays = [ (self: super: {
        jdk = super.openjdk11;
        openjdk = super.openjdk11;
      }) ]; };
    in with pkgs; buildEnv {
      name = "all";

      paths = [
#        nix-unstable # Unsure how to install this again -- this was to work around a bug where bash was incompatible with nix(? environment was completely broken)

        act  # Run github actions locally

        # bash
        nix-bash-completions
        bash-completion
        bashInteractive
#        dash  # Broken on OSX apparently

        neovim
        tmux

        git
        entr

#        git-radar
#        meld
#        tig
# 
#        mercurial

        wget
        zip
        unzip
        p7zip
        pstree
        moreutils
        gnupg

#        bc
# 
#        cloc
#        jq
#        jid
        htop

#        nodejs-8_x

        jdk
        maven
        sbt
#        haskell.compiler.ghc861
        cabal-install
        stack
#        rustc
#        cargo
#        dhall
#        dhall-json
#        dhall-text
        ipfs

#        nim
#        ponyc

        python37Full
        python37Packages.pip
        python37Packages.datadog

        terraform

        imagemagick
#        ufraw  # Requires GTK+, refuses to install in OSX. Available via homebrew though
        ffmpeg
        gifsicle
        tesseract
        ghostscript

        coreutils
        gnused
        jansson
        m4
        automake
        libtool

        ctags

#        asterisk
#        spandsp

        http-prompt
        httpie
        haproxy
        irssi
        python37Packages.tox

      ];
    };
  };
}
