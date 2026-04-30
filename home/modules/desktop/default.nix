{ lib, ... }:

{
  imports = [
    ./wayland.nix
    ./niri.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprsunset.nix
    ./wlogout.nix
    ./vpn.nix
    ./bars
    ./vicinae.nix
  ];

  options.my.desktop = {
    bar = lib.mkOption {
      type = lib.types.enum [
        "noctalia"
        "caelestia"
        "none"
      ];
      default = "none";
      description = "Shell to use";
    };

    wayland.enable = lib.mkEnableOption "Wayland utilities";
    niri.enable = lib.mkEnableOption "niri compositor integration";
    hypridle.enable = lib.mkEnableOption "hypridle idle daemon";
    hyprlock.enable = lib.mkEnableOption "hyprlock screen locker";
    hyprsunset.enable = lib.mkEnableOption "hyprsunset blue-light filter";
    wlogout.enable = lib.mkEnableOption "wlogout session menu";
    vpn.enable = lib.mkEnableOption "WireGuard VPN config";
    vicinae.enable = lib.mkEnableOption "vicinae launcher";
  };
}
