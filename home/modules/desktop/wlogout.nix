{ lib, config, ... }:

lib.mkIf config.my.desktop.wlogout.enable {
  programs.wlogout.enable = true;
}
