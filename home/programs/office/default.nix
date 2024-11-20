{ pkgs, ... }:

{
  home.packages = with pkgs; [
    onlyoffice-bin
    libreoffice
    gnome-clocks
    zathura
    # qbittorrent-nox
    feh
  ];
}
