{ inputs, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs = {
    caelestia = {
      enable = true;
      systemd = {
        enable = true;
        # target = "graphical-session.target";
        # environment = [ ];
      };
      settings = {
        paths.wallpaperDir = "~/Pictures/Wallpapers";
      };
      cli = {
        enable = true;
        settings = {
          theme.enableGtk = true;
        };
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
