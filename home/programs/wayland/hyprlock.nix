{ ... }:

{
  programs.hyprlock.enable = true;

  programs.hyprlock.settings = {
    general = {
      immediate_render = true;
      hide_cursor = true;
      ignore_empty_input = true;
    };
    background = {
      monitor = "";
      color = "rgba(16336fFF)";

      path = "/home/dmitry/Pictures/Wallpapers/MacSonoma/macos-big-sur-dark.jpg";
      blur_passes = 1;
      contrast = 0.8916;
      brightness = 0.8172;
      vibrancy = 0.1696;
      vibrancy_darkness = 0.0;
      blur_size = 15;
      # blur_passes = 4;
    };

    # INPUT FIELD
    input-field = {
      monitor = "";
      size = "260, 40";
      outline_thickness = 1;
      dots_size = 0.40; # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = true;
      outer_color = "rgba(ffffff70)";
      fail_color = "rgba(22222299)";
      inner_color = "rgba(dcdcdc50)";
      font_color = "rgba(255, 255, 255, 1)";
      fade_on_empty = true;
      font_family = "JetBrainsMono Nerd Font Mono";
      placeholder_text = "<span font_size='15pt'>Input Password...</span>";
      hide_input = false;
      position = "0, -600";
      halign = "center";
      valign = "center";
      zindex = 10;
    };

    # CLOCK/TIME
    label = [
      {
        monitor = "";
        text = "\$TIME";
        color = "rgba(255, 255, 255, 1)";
        font_size = 120;
        shadow_passes = 3;
        shadow_boost = 0.5;
        font_family = "JetBrainsMono Nerd Font Mono ExtraBold";
        position = "0, -400";
        halign = "center";
        valign = "top";
        zindex = 3;
      }

      # Battery Status
      {
        monitor = "";
        text = "cmd[update:5000] $LAYOUT[capacity=$(cat /sys/class/power_supply/BAT0/capacity) && echo 󰁹 $capacity%, ]";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "rgba(255, 255, 255, 1)";
        font_size = 18;
        font_family = "Maple Mono";
        position = "-21, -18";
        halign = "right";
        valign = "top";
        zindex = 2;
      }

      # Lock Icon
      # {
      #   monitor = "";
      #   text = "";
      #   shadow_passes = 1;
      #   shadow_boost = 0.5;
      #   color = "rgba(255, 255, 255, 1)";
      #   font_size = 17;
      #   font_family = "Font Awesome 6 Free";
      #   position = "0, -350";
      #   halign = "center";
      #   valign = "top";
      #   zindex = 2;
      # }
    ];
  };
}
