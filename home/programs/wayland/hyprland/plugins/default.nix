{ pkgs, ... }:

{
  imports = [ ./hyprexpo.nix ./pyprland.nix ];

  home.packages = with pkgs; [ hyprsunset ];
}
