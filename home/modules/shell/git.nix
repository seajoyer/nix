{
  programs = {
    git = {
      enable   = true;
      settings = {
        user.name  = "seajoyer";
        user.email = "seajoyer@gmail.com";
        init.defaultBranch = "master";
        pull.rebase = true;
      };
    };
    gh.enable = true;
  };
}
