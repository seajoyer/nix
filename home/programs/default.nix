{ config, pkgs, lib, ... }:

{
  imports = [
    ./browsers
    ./media
    ./office
    ./social
    ./wayland
    ./games
    ./art
    ./theming.nix
    # ./geant4.nix
  ];

  home.packages = with pkgs; [
    # gnome-themes-extra
    jamesdsp
    wf-recorder
    glxinfo
    glmark2
    nvtopPackages.full
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
    librecad
    libnotify
    gnome-calendar
    nix-index
    cava
    matugen
    caelestia-shell
    caelestia-cli
  ];
}
