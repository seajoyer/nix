{ inputs, pkgs, ... }:

let
  inherit (inputs.niri-scratchpad.packages.${pkgs.system}) niri-scratchpad;
in
{
  imports = [ inputs.niri-flake.homeModules.niri ];

  home.packages = [ niri-scratchpad ];
}
