{ pkgs, ... }:

{
  home.packages = with pkgs; [ 
      inkscape-with-extensions
      # blender
      gimp
  ];
}
