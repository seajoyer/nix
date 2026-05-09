{ lib, config, ... }:

lib.mkIf config.my.services.v2raya.enable {
  services.v2raya = {
    enable = true;
  };
}
