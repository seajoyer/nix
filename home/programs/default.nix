{ pkgs, ... }:

{
  imports = [
    ./art
    ./browsers
    ./games
    ./media
    ./office
    ./social
    ./theming.nix
    ./wayland
    # ./geant4.nix
  ];

  home.packages = with pkgs; [
    baobab
    bottles
    cava
    mpv
    glmark2
    mesa-demos
    gnome-calculator
    gnome-calendar
    jamesdsp
    libadwaita
    libdbusmenu-gtk3
    libnotify
    nautilus
    nix-index
    nvtopPackages.full
    optinix
    paraview
    # paraview-wayland
    pavucontrol
    pomodoro
    qbittorrent-enhanced
    swappy
    wf-recorder
    xorg.xeyes
    imagemagick
  ];

  home.file.".config/electron-flags.conf".text = ''
    --ozone-platform-hint=auto
    --enable-features=WaylandWindowDecorations
    --ozone-platform=wayland
  '';
}
