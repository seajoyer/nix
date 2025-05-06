{ pkgs, ... }:

{
  home.packages = with pkgs; [ libva-utils eog vlc ];
}
