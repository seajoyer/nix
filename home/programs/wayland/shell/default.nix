{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.ax-shell.homeManagerModules.default
  ];

  programs = {

    dankMaterialShell = { enable = false; };

    caelestia = {
      enable = true;
      systemd = {
        enable = true;
        # target = "graphical-session.target";
        # environment = [ ];
      };
      settings = { paths.wallpaperDir = "~/Pictures/Wallpapers"; };
      cli = {
        enable = true;
        settings = { theme.enableGtk = true; };
      };
    };

    ax-shell = {
      enable = false;
      settings = {
        wallpapersDir = "~/Pictures/Wallpapers/";

        bar = {
          position = "Top"; # "Top", "Bottom", "Left", "Right"
          theme = "Pills"; # "Pills", "Dense", "Edge"
        };
        dock.enable = true; # Disable the dock
        panel.theme = "Notch"; # "Notch", "Panel"
      };
    };
  };

  xdg.configFile."hypr/hypr.json".text = ''
    {
        "hyprland": {
            "style": "functional"
        }
    }
  '';

  xdg.configFile."caelestia/shell.json".source = ./shell.json;
}
