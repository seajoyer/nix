{ config, ... }:

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
      plugins = [ "git" ];
    };
    shellAliases = {
      c = "clear";
      fu = "      nix flake update ~/configs";
      sfu = "sudo nix flake update ~/configs";
      nu = "sudo nixos-rebuild switch --flake ~/configs";
      hu = "home-manager       switch --flake ~/configs";
    };
    sessionVariables = {
      YOUTUBE_API_KEY = "AIzaSyA5n2hS2aVYrm7HeHP7u0iM7ubOyVTGQ-o";
    };
    initContent = ''
      # Your existing initExtra...
      if [ -f "$HOME/.geant4-setup.sh" ]; then
        source "$HOME/.geant4-setup.sh"
      fi
    '';
  };
}
