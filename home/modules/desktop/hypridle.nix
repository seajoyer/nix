{ pkgs, lib, config, ... }:

let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # Only suspend when nothing is playing audio
    if [ $? -eq 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';

  brillo = lib.getExe pkgs.brillo;
  timeout = 300; # seconds until DPMS kicks in
in
lib.mkIf config.my.desktop.hypridle.enable {
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = lib.getExe pkgs.hyprlock;
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = timeout - 10;
          on-timeout = "${brillo} -O; ${brillo} -u 1000000 -S 10";
          on-resume = "${brillo} -I -u 500000";
        }
        {
          inherit timeout;
          on-timeout = "hyprctl dispatch dpms off";
        }
        {
          timeout = timeout + 10;
          on-timeout = suspendScript.outPath;
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
