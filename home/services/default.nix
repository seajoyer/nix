{ pkgs, ... }:

{
  imports = [ ./wayland ./fusuma.nix ./playerctl.nix ];

  home.packages = with pkgs; [
    openvpn
    openresolv
    update-resolv-conf
    hunspellDicts.en_US
    hunspellDicts.ru_RU
  ];
}
