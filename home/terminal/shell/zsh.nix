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
      size = 10000;
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
      fu = "      nix flake update ~/configs";
      sfu = "sudo nix flake update ~/configs";
      nu = "sudo nixos-rebuild switch --flake ~/configs";
      hu = "home-manager       switch --flake ~/configs";
    };
  };
}
