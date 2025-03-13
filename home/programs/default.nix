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
    # ./vpn.nix
    # ./catppuccin.nix
  ];

  home.packages = with pkgs; [
    gnome-themes-extra
    libadwaita
    libdbusmenu-gtk3
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
