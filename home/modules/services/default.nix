{ pkgs, ... }:

{
  imports = [
    ./fusuma.nix
    ./playerctl.nix
    ./udiskie.nix
    ./polkit.nix
  ];

  home.packages = with pkgs; [
    openvpn
    openresolv
    update-resolv-conf
    hunspellDicts.en_US
    hunspellDicts.ru_RU
  ];
}
