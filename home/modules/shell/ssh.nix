{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.shell.ssh.enable {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "mephi" = {
        hostname = "lesson.mephi.ru";
        user = "sidiukda";
        port = 10056;
      };
      "cluster4" = {
        hostname = "cluster4.mephi.ru";
        user = "sd015";
        identityFile = "~/.ssh/id_rsa_cluster4";
      };
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/github_personal";
        extraOptions.IdentitiesOnly = "yes";
      };
    };
  };

  # Generate a fresh Ed25519 key on first activation
  home.activation.generateSSHKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f ~/.ssh/id_ed25519 ]; then
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 \
        -f ~/.ssh/id_ed25519 -N "" \
        -C "$(whoami)@$(hostname)-$(date -I)"
      echo "Generated new Ed25519 SSH key."
    fi
  '';
}
