{ pkgs, lib, config, ... }:

lib.mkIf config.my.services.polkit.enable {
  home.packages = [ pkgs.lxqt.lxqt-policykit ];

  systemd.user.services.lxqt-policykit-agent = {
    Unit = {
      Description = "LXQt PolicyKit authentication agent";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart   = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
