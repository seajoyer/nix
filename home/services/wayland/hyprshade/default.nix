{ pkgs, ... }:

{
  home.packages = with pkgs; [ hyprshade ];

  xdg.configFile."hypr/hyprshade.toml".text = ''
    [[shades]]
    name = "blue-light-filter"
    default = true

    [[shades]]
    name = "blue-light-filter"
    start_time = 19:00:00
    end_time = 10:00:00
  '';

  xdg.configFile."hypr/shaders/blue-light-filter.glsl".source =
    ./blue-light-filter.glsl;
  xdg.configFile."hypr/shaders/invert-colors.glsl".source =
    ./invert-colors.glsl;
  xdg.configFile."hypr/shaders/color-filter.glsl".source = ./color-filter.glsl;
  xdg.configFile."hypr/shaders/grayscale.glsl".source = ./grayscale.glsl;
  xdg.configFile."hypr/shaders/vibrance.glsl".source = ./vibrance.glsl;
}
