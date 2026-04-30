{
  lib,
  config,
  inputs,
  ...
}:

lib.mkIf (config.my.desktop.bar == "caelestia") {
  # imports = [ inputs.caelestia-shell.homeModules.default ];
}
