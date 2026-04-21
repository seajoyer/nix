{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

lib.mkIf config.my.apps.browsers.enable {
  home.packages = with pkgs; [
    firefox
    google-chrome
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
