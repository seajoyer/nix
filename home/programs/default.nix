{ pkgs, ... }:

{
  imports = [
    ./browsers
    ./media
    ./office
    ./social
    ./wayland
    ./gtk.nix
    ./qt.nix
  ];

  home.packages = with pkgs; [
    gnome.gnome-calculator
    gnome.nautilus
    bottles
  ];
}
