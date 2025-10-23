{ pkgs, ... }:

{
  imports = [
    ./hypridle
    ./hyprsunset
    # ./hyprshade
  ];

  home.packages = with pkgs; [ swww ];
}
