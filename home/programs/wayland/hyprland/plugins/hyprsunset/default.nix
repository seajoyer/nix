{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ hyprsunset ];

  xdg.configFile."hypr/hypr.json".text = ''
    profile {
        temperature = 4000
    }
  '';
}
