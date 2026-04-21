{ lib, ... }:

{
  imports = [
    ./art.nix
    ./browsers.nix
    ./gaming.nix
    ./media.nix
    ./misc.nix
    ./office.nix
  ];

  options.my.apps = {
    art.enable      = lib.mkEnableOption "art tools";
    browsers.enable = lib.mkEnableOption "web browsers";
    gaming.enable   = lib.mkEnableOption "games";
    media.enable    = lib.mkEnableOption "media players";
    misc.enable     = lib.mkEnableOption "miscellaneous GUI apps";
    office.enable   = lib.mkEnableOption "office suite";
  };
}
