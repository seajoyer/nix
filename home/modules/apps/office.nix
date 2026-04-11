{
  lib,
  config,
  pkgs,
  ...
}:

lib.mkIf config.my.apps.office.enable {
  home.packages = with pkgs; [
    onlyoffice-desktopeditors
    gnome-clocks
    zathura
    evince
  ];
}
