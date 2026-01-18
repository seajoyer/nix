{ inputs, ... }:

{
  imports = [
    inputs.ax-shell.homeManagerModules.default
  ];

  programs = {
    ax-shell = {
      enable = true;
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
}
