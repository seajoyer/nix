{ pkgs, ... }:

with pkgs;
{

  bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor {};

  wl-ocr = pkgs.callPackage ./wl-ocr {};

  gols = pkgs.callPackage ./gols {};

  clipse = pkgs.callPackage ./clipse {};

  jupyterthemes = callPackage ./jupyterthemes {};

  # ipman = callPackage ./ipman {};

  # jupyterlab-vim = callPackage ./jupyterlab-vim {}; # TODO

  # catppuccin-jupyterlab = callPackage ./catppuccin-jupyterlab {}; # TODO

  # jupyterlab_darkside_theme = callPackage ./jupyterlab_darkside_theme {}; # TODO
}
