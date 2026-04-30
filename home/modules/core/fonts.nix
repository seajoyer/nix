{
  pkgs,
  lib,
  config,
  ...
}:

lib.mkIf config.my.core.fonts.enable {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    font-manager

    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    inter
    iosevka-comfy.comfy-motion
    cascadia-code
    font-awesome_6
  ];
}
