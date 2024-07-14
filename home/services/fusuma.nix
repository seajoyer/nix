{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    fusuma
    brillo
  ];

  # TODO  lib.mkIf (config.wayland.windowManager.hyprland.enable == true)

  # Hyprland-specific configuration
  services.fusuma = {
    enable = true;
    settings = {
      threshold = {
        swipe = 0.7;
      };
      interval = {
        swipe = 0.7;
      };
      swipe = {
        "4" = {
          left = {
            command = "hyprctl dispatch movewindow l";
          };
          right = {
            command = "hyprctl dispatch movewindow r";
          };
          up = {
            command = "hyprctl dispatch togglespecialworkspace minimized";
          };
          down = {
            command = "pypr toggle_special minimized";
          };
        };
      };
      hold = {
        "4" = {
          threshold = 0.3;
          command = "hyprctl dispatch hyprexpo:expo toggle";
        };
      };
      rotate = {
        "3" = {
          clockwise = {
            threshold = 0.1;
            update = {
              command = "brillo -A 0.6";
              interval = 0.001;
            };
          };
          counterclockwise = {
            threshold = 0.1;
            update = {
              command = "brillo -U 0.6";
              interval = 0.001;
            };
          };
        };
        "4" = {
          clockwise = {
            threshold = 0.1;
            update = {
              command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
              interval = 0.001;
            };
          };
          counterclockwise = {
            threshold = 0.1;
            update = {
              command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              interval = 0.001;
            };
          };
        };
      };
      plugin = {
        inputs = {
          libinput_command_input = {
            verbose = true;
          };
        };
      };
    };
  };
}
