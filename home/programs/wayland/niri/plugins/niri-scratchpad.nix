{
  pkgs,
  inputs,
  ...
}:

let
  inherit (inputs.niri-scratchpad.packages.${pkgs.system}) niri-scratchpad;
in
{
  home.packages = [ niri-scratchpad ];
}
