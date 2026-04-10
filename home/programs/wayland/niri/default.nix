{ inputs, ... }:

{
  imports = [
    inputs.niri-flake.homeModules.niri
    ./plugins/niri-scratchpad.nix
  ];
}
