{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
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

    # YOUTUBE_API_KEY removed — load from sops secret or ~/.config/env.d/
    initContent = ''
        export YOUTUBE_API_KEY="$(cat ${config.sops.secrets.youtube_api_key.path} 2>/dev/null)"
    '';
  };

  sops.secrets.youtube_api_key = {
    path = "${config.home.homeDirectory}/.config/env.d/youtube-api-key";
    mode = "0400";
  };
}
