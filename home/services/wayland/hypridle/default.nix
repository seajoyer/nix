{ pkgs, lib, config, ... }:

let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';

  _brillo = lib.getExe pkgs.brillo;

  # timeout after which DPMS kicks in
  timeout = 300;

  # TODO  lib.mkIf (config.programs.hyprlock.enable == true)
in {
  # deps
  home.packages = with pkgs; [ hypridle brillo ];

  # screen idle
  services.hypridle = {
    enable = false;

    settings = {
      general = {
        lock_cmd = lib.getExe pkgs.hyprlock;
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = timeout - 10;
          # save the current brightness and dim the screen over a period of
          # 1 second
          on-timeout = "${_brillo} -O; ${_brillo} -u 1000000 -S 10";
          # brighten the screen over a period of 500ms to the saved value
          on-resume = "${_brillo} -I -u 500000";
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
