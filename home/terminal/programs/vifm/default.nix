{ config, pkgs, lib, ... }:

let
  vifmColors = pkgs.fetchFromGitHub {
    owner = "vifm";
    repo = "vifm-colors";
    rev = "master";
    sha256 = "sha256-6kuU1+j1M5122FE8yVMlNwym/+Ea5s90LiYFTklQQZE=";
  };

  vifmLogo = pkgs.fetchurl {
    url = "https://github.com/vifm/vifm/raw/master/data/graphics/vifm.png";
    sha256 = "sha256-QK8b4FTz3UOY78rXt2GPsT45BU2uhN/M/Rb9hljRBUc=";
  };
in {
  home.packages = with pkgs; [ vifm git ];

  xdg = {
    configFile = {
      "vifm/vifmrc".source = ./vifmrc;

      "vifm/scripts/extract" = {
        source = ./extract;
        executable = true;
      };

      "vifm/colors" = {
        source = "${vifmColors}";
        recursive = true;
      };
    };

    dataFile = {
      "applications/vifm.png".source = "${vifmLogo}";

      "applications/vifm.desktop".text = ''
        [Desktop Entry]
        Name=Vifm
        Exec=kitty --override window_padding_width="0 0 0" vifm %f
        Type=Application
        Icon=${config.xdg.dataHome}/applications/vifm.png
        Terminal=true
        MimeType=inode/directory;
      '';
    };
  };
}
