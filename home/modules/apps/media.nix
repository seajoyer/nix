{
  lib,
  config,
  pkgs,
  ...
}:

lib.mkIf config.my.apps.media.enable {
  home.packages = with pkgs; [ libva-utils eog vlc ];
}
