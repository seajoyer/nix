{ pkgs, ... }:
{
  home.packages = [ pkgs.lxqt.lxqt-policykit ];
  systemd.user.services.lxqt-policykit-agent = {
    Unit.Description  = "LXQt PolicyKit authentication agent";
    Unit.After        = [ "graphical-session.target" ];
    Unit.PartOf       = [ "graphical-session.target" ];
    Service.ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
    Service.Restart   = "on-failure";
    Install.WantedBy  = [ "graphical-session.target" ];
  };
}
