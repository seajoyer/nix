{ pkgs, ... }:

{
    home.packages = with pkgs; [
        hyprshade
        swww
    ];
}
