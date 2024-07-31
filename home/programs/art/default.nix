{ pkgs, ... }:

{
  home.packages = with pkgs; [ krita inkscape-with-extensions ];
}
