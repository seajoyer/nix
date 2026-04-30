{ lib, config, ... }:

lib.mkIf config.my.desktop.hyprsunset.enable {
  services.hyprsunset = {
    enable = true;
    settings.profile = [
      {
        time = "7:30";
        temperature = 4500;
      }
      {
        time = "20:30";
        temperature = 4000;
      }
    ];
  };
}
