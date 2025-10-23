{ inputs, pkgs, ... }:

{
  # wayland.windowManager.hyprland = {
  #   plugins = [
  #     inputs.hyprtasking.packages.${pkgs.system}.hyprtasking
  #   ];
  # };

  imports = [
    # ./hyprexpo.nix
    ./pyprland.nix
  ];
}
