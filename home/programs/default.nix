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
    baobab
    gnome-calculator
    nautilus
    obsidian
    bottles
    swappy
    xorg.xeyes
    pomodoro
  ];
}
