{ pkgs, ... }:

{
  home.packages = with pkgs; [
    onlyoffice-desktopeditors
    gnome-clocks
    zathura
    evince
    # qbittorrent-nox
    feh
  ];
}
