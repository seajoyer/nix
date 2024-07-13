{config, ...}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      save = 100000;
      size = 1000;
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
    shellAliases = {
      c = "clear";
      nu = "sudo nixos-rebuild switch --flake ~/nixHome";
      hu = "home-manager       switch --flake ~/nixHome";
    };
  };
}
