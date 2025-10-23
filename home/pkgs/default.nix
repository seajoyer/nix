{ pkgs, ... }:

let
  packages = with pkgs; rec {

    paraview-wayland = pkgs.callPackage ./paraview-wayland { };

    bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor { };

    wl-ocr = pkgs.callPackage ./wl-ocr { };

    gols = pkgs.callPackage ./gols { };

    clipse = pkgs.callPackage ./clipse { };

    jupyterthemes = callPackage ./jupyterthemes { };

    ax-shell = callPackage ./ax-shell { };

    caelestia-shell = callPackage ./caelestia/shell.nix { };

    caelestia-cli = callPackage ./caelestia/cli.nix { };

    # ipman = callPackage ./ipman {};

    # jupyterlab-vim = callPackage ./jupyterlab-vim {};

    # catppuccin-jupyterlab = callPackage ./catppuccin-jupyterlab {};

    # jupyterlab_darkside_theme = callPackage ./jupyterlab_darkside_theme {};
  };
in packages
