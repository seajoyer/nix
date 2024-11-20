{ pkgs, ... }:

{
  home.packages = with pkgs; [ krita inkscape-with-extensions blender gimp ];
}
