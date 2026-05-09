{ lib, config, ... }:

lib.mkIf config.my.desktop.hyprlock.enable {
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        immediate_render   = false;
        hide_cursor        = true;
        ignore_empty_input = true;
      };

      background = {
        monitor    = "";
        color      = "rgba(16336fFF)";
        path       = "/home/dmitry/Pictures/Wallpapers/earth_from_space.png";
        blur_passes   = 3;
        blur_size     = 13;
      };

      input-field = [{
        monitor         = "";
        size            = "300, 45";
        outline_thickness = 2;
        dots_size       = 0.35;
        dots_spacing    = 0.22;
        dots_center     = true;
        rounding        = 12;
        outer_color     = "rgba(eeeeeeaf)";
        inner_color     = "rgba(111111aa)";
        font_color      = "rgba(eeeeeeaf)";
        fade_on_empty   = true;
        font_family     = "JetBrainsMono Nerd Font Mono";
        placeholder_text = "<span font_size='14pt'>Password...</span>";
        hide_input      = false;
        position        = "0, -600";
        halign          = "center";
        valign          = "center";
        zindex          = 20;
      }];

      label = [
        {
          monitor     = "";
          text        = "$TIME";
          color       = "rgba(255, 255, 255, 1)";
          font_size   = 120;
          font_family = "JetBrainsMono Nerd Font Mono ExtraBold";
          shadow_passes = 3;
          shadow_boost  = 0.5;
          position    = "0, -400";
          halign      = "center";
          valign      = "top";
          zindex      = 3;
        }
        {
          monitor     = "";
          text        = "cmd[update:5000] $LAYOUT[capacity=$(cat /sys/class/power_supply/BAT0/capacity) && echo 󰁹 $capacity%, ]";
          color       = "rgba(255, 255, 255, 0.7)";
          font_size   = 14;
          font_family = "Maple Mono";
          shadow_passes = 1;
          shadow_boost  = 0.5;
          position    = "21, 18";
          halign      = "left";
          valign      = "bottom";
          zindex      = 2;
        }
      ];
    };
  };
}
