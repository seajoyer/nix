{
  lib,
  config,
  pkgs,
  ...
}:

lib.mkIf config.my.apps.browsers.enable {
  home.packages = with pkgs; [
    firefox
    google-chrome
  ];
}
