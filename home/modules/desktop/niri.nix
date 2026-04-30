{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (inputs.niri-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}) niri-scratchpad;
in
lib.mkIf config.my.desktop.niri.enable {
  home.packages = [ niri-scratchpad ];
}
