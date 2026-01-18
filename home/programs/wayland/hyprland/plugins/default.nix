{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    plugins = [
      # inputs.hyprtasking.packages.${pkgs.system}.hyprtasking
      pkgs.hyprselect
      pkgs.hyprlandPlugins.hyprscrolling
    ];
  };

  imports = [
    # ./hyprexpo.nix
    ./pyprland.nix
  ];
  
  wayland.windowManager.hyprland = {
    extraConfig = ''
      exec-once = pypr &
    '';
  };
}
