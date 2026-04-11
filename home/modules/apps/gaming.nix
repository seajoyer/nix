{
  lib,
  config,
  pkgs,
  ...
}:

lib.mkIf config.my.apps.gaming.enable {
  home.packages = with pkgs; [ mindustry-wayland ];
}
