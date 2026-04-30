{
  pkgs,
  lib,
  config,
  ...
}:

lib.mkIf config.my.core.xdg.enable {
  home.packages = with pkgs; [ xdg-utils ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = false;
    };

    configFile."bat/config".text = ''
      --theme="Nord"
      --italic-text=always
      --map-syntax='.ignore:Git Ignore'
    '';
  };
}
