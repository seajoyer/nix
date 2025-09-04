{ pkgs, ... }:

{
  imports = [
    # ./hypridle
    # ./hyprshade
  ];

  home.packages = with pkgs; [ swww ];
}
