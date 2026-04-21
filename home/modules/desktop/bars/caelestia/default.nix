{ lib, config, ... }:

lib.mkIf (config.my.desktop.bar == "caelestia") {
  # Uncomment when the caelestia flake input is re-added to flake.nix:
  # imports = [ inputs.caelestia-shell.homeModules.default ];
}
