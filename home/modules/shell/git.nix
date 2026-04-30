{ lib, config, ... }:

lib.mkIf config.my.shell.git.enable {
  programs = {
    git = {
      enable   = true;
      settings = {
        user.name  = "seajoyer";
        user.email = "seajoyer@gmail.com";
        init.defaultBranch = "master";
        pull.rebase = true;
      };
      signing.format = null;
    };
    gh.enable = true;
  };
}
