{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    # extraConfig = builtins.readFile ./shell.json;
    enable = true;
    systemd.enable = true; # if you prefer starting from your compositor
    settings = {
      bar.status = { showBattery = true; };
      paths.wallpaperDir = "~/Pictures/Wallpapers";
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = { theme.enableGtk = true; };
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
