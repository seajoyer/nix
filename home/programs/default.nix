{ pkgs, ... }:

{
  imports = [
    ./browsers
    ./media
    ./office
    ./social
    ./wayland
    ./games
    ./art
    ./gtk.nix
    ./qt.nix
    ./catppuccin.nix
  ];

  home.packages = with pkgs; [
    gnome-calculator
    nautilus
    obsidian
    bottles
    swappy
  ];
}
