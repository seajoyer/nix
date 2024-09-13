{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "mephi" = {
        hostname = "nti.mephi.ru";
        user = "sidiukd";
        port = 10177;
      };
      "github.com" = {
	user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  home.file.".ssh/id_ed25519" = {
    source = ./id_ed25519;
  };

  home.file.".ssh/id_ed25519.pub" = {
    source = ./id_ed25519.pub;
  };
}
