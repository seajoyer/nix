{ pkgs, lib, ... }:

{
  programs.btop = {
    enable   = true;
    settings = {
      color_theme      = lib.mkForce "dracula";
      theme_background = false;
      vim_keys         = true;
      update_ms        = 1000;
    };
  };

  programs.cava.enable = true;

  programs.direnv = {
    enable            = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    # monitoring
    batmon

    # search & text processing
    ripgrep
    bat
    tree
    jq
    bc

    # archive
    unzip
    p7zip

    # system utilities
    killall
    execline
    sops
    curl
    wget
    ghostscript

    # clipboard
    clipse

    # fancy ls
    # gols

    # eye candy
    fastfetch
    tty-clock
    cbonsai
    unimatrix
    asciiquarium
    pipes
    pfetch
    cowsay
    cava
  ];
}
