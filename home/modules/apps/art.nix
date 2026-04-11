{
  lib,
  config,
  pkgs,
  ...
}:

lib.mkIf config.my.apps.art.enable {
  home.packages = with pkgs; [
    inkscape-with-extensions
    blender
    gimp
  ];
}
