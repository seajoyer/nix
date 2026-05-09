{ lib, config, ... }:

lib.mkIf config.my.services.wluma.enable {
  services.wluma = {
    enable = true;
  };
}
