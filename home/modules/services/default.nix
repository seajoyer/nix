{ pkgs, lib, ... }:

{
  imports = [
    ./fusuma.nix
    ./playerctl.nix
    ./udiskie.nix
    ./polkit.nix
  ];

  options.my.services = {
    fusuma.enable   = lib.mkEnableOption "fusuma touchpad gestures";
    playerctl.enable = lib.mkEnableOption "playerctl media control daemon";
    udiskie.enable  = lib.mkEnableOption "udiskie automounter";
    polkit.enable   = lib.mkEnableOption "LXQt polkit agent";
  };

  config.home.packages = with pkgs; [
    openvpn
    openresolv
    update-resolv-conf
    hunspellDicts.en_US
    hunspellDicts.ru_RU
  ];
}
