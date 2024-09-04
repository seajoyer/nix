{ config, inputs, pkgs, ... }:
let
  # variant = "dark";
  # c = config.programs.matugen.theme.colors.colors.${variant};

  font_family = "Inter";
in {
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        # disable_loading_bar = true;
        # hide_cursor = false;
        no_fade_in = true;
        grace = 3;
      };

      background = [{
        path =
          "/home/dmitry/Pictures/Wallpapers/cat_leaves.png"; # config.my.wallpaper;
        blur_passes = 6; # 0 disables blurring
        blur_size = 4;
        noise = "1.17e-2";
        brightness = 0.6;
      }];

      input-field = [{
        size = "220, 37";
        fade_on_empty = true;

        outline_thickness = 2;
        dots_size = 0.38;
        dots_spacing = 0.18;
        dots_center = true;

        # outer_color = "rgb(${c.primary})";
        # inner_color = "rgb(${c.on_primary_container})";
        # font_color = "rgb(${c.primary_container})";
        fail_text = "<b>$ATTEMPTS</b>";
        fail_color = "rgb(220, 20, 60)";

        placeholder_text = "<b>Input Password...</b>";
        color = "rgba(230, 230, 230, 1.0)";

        position = "0, 30";
        halign = "center";
        valign = "bottom";
      }];

      label = [
        {
          text = "$TIME";
          color = "rgba(230, 230, 230, 1.0)";
          inherit font_family;
          font_size = 80;
          position = "0, 85";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:3600000] $LAYOUT[date +'%B %d', date +'%d %B']";
          color = "rgba(230, 230, 230, 1.0)";
          inherit font_family;
          font_size = 20;
          position = "0, -15";
          valign = "center";
          halign = "center";
        }
      ];
    };
  };
}
