{ inputs, ... }:

{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  programs = {
    dankMaterialShell = {
      enable = true;

      systemd = {
        enable = true;
        restartIfChanged = true;
      };
    };
  };
}
