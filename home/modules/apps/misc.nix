{ lib, config, pkgs, ... }:

lib.mkIf config.my.apps.misc.enable {
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
    xeyes
    imagemagick
    telegram-desktop
    devenv
    sassc
    ovito
    evtest
  ];
}
