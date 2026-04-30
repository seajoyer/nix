{ lib, config, ... }:

lib.mkIf config.my.terminal.nushell.enable {
  programs.nushell.enable = true;
}
