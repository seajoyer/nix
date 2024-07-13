{ pkgs, ... }:

{
  imports = [
    ./browsers
    ./media
    ./office
    ./social
    ./wayland
  ];

  home.packages = with pkgs; [
    bottles
  ];
}
