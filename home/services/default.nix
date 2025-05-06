{ pkgs, ... }:

{
  imports = [ ./wayland ./fusuma.nix ./playerctl.nix ];

  home.packages = with pkgs; [
    dig
    openvpn
    openresolv
    update-resolv-conf
    vpn-slice
    hunspellDicts.en_US
    hunspellDicts.ru_RU
  ];
}
