{ config, ... }:

{
  programs.zsh = {
    enable                    = true;
    enableCompletion          = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      save = 5000000;
      size = 10000;
    };

    oh-my-zsh = {
      enable  = true;
      theme   = "robbyrussell";
      plugins = [ "git" ];
    };

    shellAliases = {
      c   = "clear";
      fu  = "nix flake update ~/configs";
      nu  = "sudo nixos-rebuild switch --flake ~/configs";
      hu  = "home-manager switch --flake ~/configs";
    };

    initContent = ''
      export YOUTUBE_API_KEY="$(cat ${config.sops.secrets.youtube_api_key.path} 2>/dev/null)"

      if [ -f "$HOME/.geant4-setup.sh" ]; then
        source "$HOME/.geant4-setup.sh"
      fi
    '';

    dotDir = "${config.xdg.configHome}/zsh";
  };

  sops.secrets.youtube_api_key = {
    path = "${config.home.homeDirectory}/.config/env.d/youtube-api-key";
    mode = "0400";
  };
}
