
{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # an app
    font-manager

    # fonts
    (nerdfonts.override {
      fonts = [
        "NerdFontsSymbolsOnly"
        "JetBrainsMono"
        "Iosevka"
      ];
    })
    inter
    iosevka-comfy.comfy-motion
    cascadia-code
  ];
}
