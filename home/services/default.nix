{ pkgs, ... }:

{
  imports = [
    ./ags
    ./wayland
    ./fusuma.nix
    ./playerctl.nix
  ];

  home.packages = with pkgs; [ hunspellDicts.en_US hunspellDicts.ru_RU ];
}
