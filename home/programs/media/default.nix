{ pkgs, ... }:

{
  home.packages = with pkgs; [ libva-utils gnome.eog vlc ];
}
