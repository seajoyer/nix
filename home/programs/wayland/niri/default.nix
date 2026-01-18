{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.niri-flake.homeModules.niri
  ];

  programs.niri = {
    # enable = true;
    # settings = {
    #   input = {
    #     keyboard.xkb.layout = "us";
    #   };

    #   layout = {
    #     gaps = 16;
    #     center-focused-column = "never";
        
    #     preset-column-widths = [
    #       { proportion = 0.33333; }
    #       { proportion = 0.5; }
    #       { proportion = 0.66667; }
    #     ];
    #   };

    #   window-rules = [
    #     {
    #       geometry-corner-radius = {
    #         bottom-left = 6.0;
    #         bottom-right = 6.0;
    #         top-left = 6.0;
    #         top-right = 6.0;
    #       };
    #       clip-to-geometry = true;
    #     }
    #   ];

    #   binds = with config.lib.niri.actions; {
    #     "Mod+T".action = spawn "alacritty";
    #     "Mod+D".action = spawn "fuzzel";
    #     "Mod+Q".action = close-window;
    #   };
    # };
  };
}
