{ lib, ... }:

{
  imports = [
    ./kitty.nix
    ./ghostty.nix
  ];

  options.my.terminal = {
    ghostty.enable = lib.mkEnableOption "ghostty terminal emulator";
    kitty.enable   = lib.mkEnableOption "kitty terminal emulator";
  };
}
