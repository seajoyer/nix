{ pkgs, lib, config, ... }:

lib.mkIf config.my.services.playerctl.enable {
  home.packages = with pkgs; [ playerctl ];
  services.playerctld.enable = true;
}
