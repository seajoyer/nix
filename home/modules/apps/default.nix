{ lib, ... }:

{
  imports = [
    ./art.nix
    ./gaming.nix
    ./browsers.nix
    ./media.nix
    ./office.nix
    ./misc.nix
  ];

  options.my.apps = {
    art.enable      = lib.mkEnableOption "Doom Emacs";
    gaming.enable   = lib.mkEnableOption "Vim";
    browsers.enable = lib.mkEnableOption "Browsers";
    media.enable    = lib.mkEnableOption "Media";
    office.enable   = lib.mkEnableOption "Office";
    misc.enable     = lib.mkEnableOption "Misc";
  };

  home.file.".config/electron-flags.conf".text = ''
    --ozone-platform-hint=auto
    --enable-features=WaylandWindowDecorations
    --ozone-platform=wayland
  '';
}
