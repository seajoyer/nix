{ lib, ... }:

{
  imports = [
    ./fonts.nix
    ./theming.nix
    ./xdg.nix
  ];

  options.my.core = {
    xdg.enable     = lib.mkEnableOption "xdg, portals, etc.";
    fonts.enable   = lib.mkEnableOption "fonts";
    theming.enable = lib.mkEnableOption "theming: xdg, qt, dconf, etc.";
  };
}
