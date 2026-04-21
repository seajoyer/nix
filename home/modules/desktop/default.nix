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
      type        = lib.types.enum [ "noctalia" "caelestia" "none" ];
      default     = "none";
      description = "Shell to enable.";
    };
  };
}
