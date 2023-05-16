# nix-shell shell_test.nix --argstr commitNixpkgs "b1f2eefb227c0fa7b19591570401aff38f752137 --show-trace

{ commitNixpkgs ? "b1f2eefb227c0fa7b19591570401aff38f752137" }:

let
  nixpkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${commitNixpkgs}.tar.gz") {config= { allowUnfree = true ; } ;} ;

  pkgs = [
    nixpkgs.terraform
    nixpkgs.terragrunt
  ];
in
  nixpkgs.stdenv.mkDerivation {
    name = "env";
    buildInputs = pkgs;
  }
