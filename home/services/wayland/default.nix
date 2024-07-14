{ pkgs, ... }:

{
  imports = [ ./hypridle ];

  home.packages = with pkgs; [ hyprshade swww ];
}
