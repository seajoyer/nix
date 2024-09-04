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
    gnome.gnome-calculator
    gnome.nautilus
    bottles
    swappy
  ];
}
