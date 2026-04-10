{ pkgs, ... }:

{
  imports = [
    # ./art
    ./browsers
    ./games
    ./media
    ./office
    ./theming.nix
    ./wayland
    # ./geant4.nix
  ];

  home.packages = with pkgs; [
    obs-studio
    baobab
    pciutils
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
    pavucontrol
    pomodoro
    qbittorrent-enhanced
    wf-recorder
    xorg.xeyes
    imagemagick
    telegram-desktop
  ];

  home.file.".config/electron-flags.conf".text = ''
    --ozone-platform-hint=auto
    --enable-features=WaylandWindowDecorations
    --ozone-platform=wayland
  '';
}
