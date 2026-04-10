{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xdg-utils
  ];

  xdg = {
    enable = true;
    userDirs.enable = true;

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config = {
        common.default = [ "gtk" ];

        gnome = {
          default = [
            "gnome"
            "gtk"
          ];
        };

        niri = {
          default = [
            "gnome"
          ];
          # "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          # "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          # "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        };
      };
    };

    configFile = {
      "bat/config".text = ''
        --theme="Nord"
        --italic-text=always
        --map-syntax='.ignore:Git Ignore'
      '';
    };
  };
}
