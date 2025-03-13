{ config, lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "mephi" = {
        hostname = "lesson.mephi.ru";
        user = "sidiukda";
        port = 10056;
      };
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  # Generate Ed25519 key if it doesn't exist
  home.activation.generateSSHKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f ~/.ssh/id_ed25519 ]; then
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "$(whoami)@$(hostname)-$(date -I)"
      echo "Generated new Ed25519 SSH key"
    else
      echo "Ed25519 SSH key already exists"
    fi
  '';
}
