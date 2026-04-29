{ pkgs, ... }:

{
  home.packages = with pkgs; [ xdg-utils ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = false;
    };

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config = {
        common.default = [ "gtk" ];
        niri.default = [
          "gnome"
          "gtk"
        ];
      };
    };

    configFile."bat/config".text = ''
      --theme="Nord"
      --italic-text=always
      --map-syntax='.ignore:Git Ignore'
    '';
  };
}
