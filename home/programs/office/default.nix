{ pkgs, ... }:

{
  home.packages = with pkgs; [ onlyoffice-bin gnome.gnome-clocks zathura qbittorrent ];
}
