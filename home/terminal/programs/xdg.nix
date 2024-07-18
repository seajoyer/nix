{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ xdg-utils ];

  xdg = {
    enable = true;
    userDirs.enable = true;

    mimeApps.defaultApplications = {
      "application/pdf" = [ "zathura.desktop" ];
      "inode/directory" = [ "vifm.desktop" ];
    };

    configFile = with config.xdg; {
      "bat/config".text = ''
        --theme="Nord"
        --italic-text=always
        --map-syntax='.ignore:Git Ignore'
      '';
    };
    # portal = {
    #   enable = true;
    #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # };
  };
}
