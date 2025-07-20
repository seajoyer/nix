{ pkgs, ... }:

{
  home.packages = with pkgs; [
    onlyoffice-bin
    libreoffice
    gnome-clocks
    zathura
    evince
    # qbittorrent-nox
    feh
  ];
}
