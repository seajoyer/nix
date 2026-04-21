{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fusuma
    brillo
  ];

  services.fusuma = {
    enable = true;
    settings = {
      threshold.swipe = 0.7;
      interval.swipe = 0.7;

      hold."4" = {
        threshold = 0.3;
        command = "hyprctl dispatch hyprexpo:expo toggle";
      };

      rotate = {
        "3" = {
          clockwise = {
            threshold = 0.1;
            update = {
              command = "brillo -A 0.5";
              interval = 1.0e-3;
            };
          };
          counterclockwise = {
            threshold = 0.1;
            update = {
              command = "brillo -U 0.3";
              interval = 1.0e-3;
            };
          };
        };
        "4" = {
          clockwise = {
            threshold = 0.1;
            update = {
              command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5%+";
              interval = 1.0e-3;
            };
          };
          counterclockwise = {
            threshold = 0.1;
            update = {
              command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5%-";
              interval = 1.0e-3;
            };
          };
        };
      };

      plugin.inputs.libinput_command_input.verbose = true;
    };
  };
}
