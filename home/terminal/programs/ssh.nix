{ config, ... }:

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
}
