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
    ./theming.nix
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
  ];
}
