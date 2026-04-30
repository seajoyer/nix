{ lib, ... }:

{
  imports = [ ./kitty.nix ];

  options.my.terminal = {
    kitty.enable   = lib.mkEnableOption "kitty terminal emulator";
    nushell.enable = lib.mkEnableOption "nushell";
  };
}
