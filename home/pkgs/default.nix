{ pkgs, ... }:

with pkgs;
{

  bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor {};

  wl-ocr = pkgs.callPackage ./wl-ocr {};

  gols = pkgs.callPackage ./gols {};

  clipse = pkgs.callPackage ./clipse {};
}
