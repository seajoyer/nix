{ lib, config, ... }:

lib.mkIf config.my.services.udiskie.enable {
  services.udiskie = {
    enable = true;
    tray   = "never";
  };
}
