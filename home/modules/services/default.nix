{ pkgs, lib, ... }:

{
  imports = [
    ./fusuma.nix
    ./playerctl.nix
    ./udiskie.nix
    ./polkit.nix
    ./wluma.nix
  ];

  options.my.services = {
    fusuma.enable    = lib.mkEnableOption "fusuma touchpad gestures";
    playerctl.enable = lib.mkEnableOption "playerctl media control daemon";
    udiskie.enable   = lib.mkEnableOption "udiskie automounter";
    polkit.enable    = lib.mkEnableOption "LXQt polkit agent";
    wluma.enable     = lib.mkEnableOption "Wluma adaptive brightness";
    v2raya.enable    = lib.mkEnableOption "Web GUI client";
  };

  config.home.packages = with pkgs; [
    openvpn
    openresolv
    update-resolv-conf
    hunspellDicts.en_US
    hunspellDicts.ru_RU
  ];
}
