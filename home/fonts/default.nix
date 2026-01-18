
{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # an app
    font-manager

    # fonts
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    inter
    iosevka-comfy.comfy-motion
    cascadia-code
    font-awesome_6
  ];
}
